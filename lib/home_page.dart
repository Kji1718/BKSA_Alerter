import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:bksa_alerter/theme_service.dart';
import 'globals.dart' as globals;
import 'notification_details_page.dart';

class Notification {
  final String title;
  final String time;
  final Map<String, dynamic> data;

  Notification({required this.title, required this.time, required this.data});

  factory Notification.fromJson(Map<String, dynamic> json) {
    final String date = DateFormat('dd-MM-yyyy - kk:mm').format(
        DateTime.fromMillisecondsSinceEpoch(json["completed_at"] * 1000));
    return Notification(
      title: json['contents']['en'],
      time: date,
      data: json['data'] ?? {},
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Notification>> futureNotification;

  Future<List<Notification>> getNotificationData() async {
    try {
      final url = Uri.parse(
          "${dotenv.env['API_URL'] ?? 'https://api.onesignal.com/notifications'}?app_id=${dotenv.env['APP_ID'] ?? '0'}&limit=50&offset=0&kind=1");

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader:
              'Basic ${dotenv.env['API_KEY'] ?? ''}',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        List<Notification> notifications = [];
        for (var notify in jsonData['notifications']) {
          notifications.add(Notification.fromJson(notify));
        }
        return notifications;
      } else {
        throw Exception('Failed to load notification data');
      }
    } catch (e) {
      print("Error occurred: $e");
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    futureNotification = getNotificationData();
    initPlatformState();
  }

  Future<void> initPlatformState() async {

    OneSignal.Notifications.addClickListener((event) {
     var title = event.notification.rawPayload?['alert'];
      var data = event.notification.additionalData;
      globals.appNavigator.currentState?.push(
        MaterialPageRoute(
          builder: (context) => NotificationPage(
              title: title.toString(), data: data ?? <String, dynamic>{}),
        ),
      ); 
    });
    // OneSignal.shared
    //     .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    //   var title = result.notification.rawPayload?['alert'];
    //   var data = result.notification.additionalData;
    //   globals.appNavigator.currentState?.push(
    //     MaterialPageRoute(
    //       builder: (context) => NotificationPage(
    //           title: title.toString(), data: data ?? <String, dynamic>{}),
    //     ),
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {
            futureNotification = getNotificationData();
          });
          return futureNotification;
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Column(
            children: [
              _filterBar(),
              _showNotifications(),
            ],
          ),
        ),
      ),
    );
  }

  var _isDark = Get.isDarkMode;
  String searchString = "";

  _appBar() {
    return AppBar(
      title: const Text('BKSA Alerter'),
      actions: [
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(
            _isDark ? Icons.nightlight_rounded : Icons.wb_sunny_rounded,
            size: 24,
          ),
          tooltip: 'Change Theme',
          onPressed: () {
            ThemeServices().switchTheme();
            setState(() => _isDark = !_isDark);
          },
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  _filterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchString = value.toLowerCase();
          });
        },
        decoration: InputDecoration(
          labelText: 'Search',
          suffixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }

  _showNotifications() {
    return Expanded(
      child: FutureBuilder<List<Notification>>(
        future: futureNotification,
        builder: (context, AsyncSnapshot<List<Notification>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No notifications available'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final severity = snapshot.data![index].data["severity"];
                Color cardColor;

                if (severity == 'critical') {
                  cardColor = Theme.of(context).colorScheme.error;
                } else if (severity == 'high') {
                  cardColor =
                      Colors.deepOrangeAccent; // Custom color for high severity
                } else if (severity == 'medium') {
                  cardColor = Colors.amber; // Custom color for medium severity
                } else if (severity == 'low') {
                  cardColor = Colors.lightBlue; // Custom color for low severity
                } else {
                  cardColor = Theme.of(context).colorScheme.surface;
                }

                return snapshot.data![index].title
                        .toLowerCase()
                        .contains(searchString)
                    ? Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Card(
                          color: cardColor,
                          child: ListTile(
                            leading: Icon(
                              Icons.add_alert,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            title: Text(
                              snapshot.data![index].title,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            subtitle: Text(
                              snapshot.data![index].time,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            trailing: Icon(
                              Icons.keyboard_arrow_right,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotificationPage(
                                    title: snapshot.data![index].title,
                                    data: snapshot.data![index].data,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Container();
              },
            );
          }
        },
      ),
    );
  }
}

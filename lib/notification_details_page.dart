import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  final String title;
  final Map<String, dynamic> data;

  const NotificationPage({Key? key, required this.title, required this.data})
      : super(key: key);
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    final severity = widget.data["severity"];
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Details'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: cardColor,
              child: const Icon(
                Icons.notifications,
                size: 60,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Center(
              child: Text(
                widget.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 16.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 4,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: List.generate(
                  widget.data.length,
                  (index) {
                    if (widget.data.values.elementAt(index) != "") {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: ListTile(
                          title: Text(
                            widget.data.keys.elementAt(index),
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 18),
                          ),
                          trailing: SizedBox(
                            width:
                                150, // You can adjust this width according to your UI needs
                            child: Text(
                              widget.data.values.elementAt(index),
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 18),
                              overflow: TextOverflow
                                  .ellipsis, // This will ensure that long text is truncated
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

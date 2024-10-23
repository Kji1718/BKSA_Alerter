import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:bksa_alerter/theme.dart';
import 'package:bksa_alerter/theme_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'home_page.dart';
import 'globals.dart' as globals;

void main() async {
  await dotenv.load(fileName: ".env");
  globals.appNavigator = GlobalKey<NavigatorState>();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  // OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);
  // OneSignal.shared.setAppId("0590741a-bb4b-4f39-ab91-8b03404e5f4f");

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize('0590741a-bb4b-4f39-ab91-8b03404e5f4f');
  OneSignal.Notifications.requestPermission(true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BKSA Alerter',
      debugShowCheckedModeBanner: false,
      theme: Themes.lightThemeData(context),
      darkTheme: Themes.darkThemeData(),
      themeMode: ThemeMode.light,
      navigatorKey: globals.appNavigator,
      home: Home(),
    );
  }
}

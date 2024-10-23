import 'package:flutter/material.dart';

class Palette {
  static MaterialColor bluishToDark = const MaterialColor(
    0xff42276a,
    <int, Color>{
      50: Color(0xff3b235f), //10%
      100: Color(0xff351f55), //20%
      200: Color(0xff2e1b4a), //30%
      300: Color(0xff281740), //40%
      400: Color(0xff211435), //50%
      500: Color(0xff1a102a), //60%
      600: Color(0xff140c20), //70%
      700: Color(0xff0d0815), //80%
      800: Color(0xff07040b), //90%
      900: Color(0xff000000), //100%
    },
  );

  static MaterialColor greyToDark = const MaterialColor(
    0xff121212,
    <int, Color>{
      50: Color(0xff101010), //10%
      100: Color(0xff0e0e0e), //20%
      200: Color(0xff0d0d0d), //30%
      300: Color(0xff0b0b0b), //40%
      400: Color(0xff090909), //50%
      500: Color(0xff070707), //60%
      600: Color(0xff050505), //70%
      700: Color(0xff040404), //80%
      800: Color(0xff020202), //90%
      900: Color(0xff000000), //100%
    },
  );
}

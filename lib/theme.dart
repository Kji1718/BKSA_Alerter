import 'package:flutter/material.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

class Themes {
  static ThemeData lightThemeData(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromRGBO(86, 80, 14, 171),
        brightness: Brightness.light,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          inherit: true,
          color: Colors.black,
          fontFamily: 'Roboto',
          fontSize: 57.0,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.3,
          height: 1.1,
        ),
        bodyLarge: TextStyle(
          inherit: true,
          color: Colors.black,
          fontFamily: 'Roboto',
          fontSize: 18.0,
        ),
        bodySmall: TextStyle(
          inherit: true,
          color: Colors.black54,
          fontFamily: 'Roboto',
          fontSize: 14.0,
        ),
      ),
    );
  }

  static ThemeData darkThemeData() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromRGBO(86, 80, 14, 171),
        brightness: Brightness.dark,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          inherit: true,
          color: Color(0xb3ffffff),
          fontFamily: 'Roboto',
          fontSize: 57.0,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.3,
          height: 1.1,
        ),
        bodyLarge: TextStyle(
          inherit: true,
          color: Colors.white,
          fontFamily: 'Roboto',
          fontSize: 18.0,
        ),
        bodySmall: TextStyle(
          inherit: true,
          color: Colors.white70,
          fontFamily: 'Roboto',
          fontSize: 14.0,
        ),
      ),
    );
  }
}

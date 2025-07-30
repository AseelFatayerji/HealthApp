import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Colors.grey.shade300,
    surface: Colors.grey.shade200,
  ),
  scaffoldBackgroundColor: Colors.white,
  cardColor: Colors.grey.shade400,
  splashColor: Colors.black,
  textTheme: TextTheme(
    bodySmall: TextStyle(color: Colors.grey),
    bodyMedium: TextStyle(color: Colors.black),
    bodyLarge: TextStyle(color: Colors.grey.shade800),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  cardColor: Colors.grey,
  colorScheme: ColorScheme.dark(
    primary: Colors.grey.shade300,
    surface: Colors.grey.shade800,
  ),
  scaffoldBackgroundColor: Colors.grey.shade900,
  splashColor: Colors.white,
  textTheme: TextTheme(
    bodySmall: TextStyle(color: Colors.grey.shade100),
    bodyMedium: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.grey.shade300),
  ),
);

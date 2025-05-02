import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    hintColor: Colors.grey[600],
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 16),
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.blue,
    ).copyWith(secondary: Colors.amber, surface: Colors.green),
    scaffoldBackgroundColor: Colors.deepOrange,
  );

  static final ThemeData darktheme = ThemeData(
    primarySwatch: Colors.blueGrey,
    hintColor: Colors.grey[900],
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 16),
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.blue,
    ).copyWith(secondary: Colors.amber, surface: Colors.green),
    scaffoldBackgroundColor: Colors.deepOrange,
  );
}

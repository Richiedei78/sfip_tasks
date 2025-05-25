import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: Colors.teal, // Beruhigendes Blau-Grün für die Hauptnavigation
      secondary: Colors.amber, // Akzentfarbe für Buttons oder wichtige Tasks
      surface: Colors.white, // Hintergrundfarbe für Cards und Widgets
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
    ),
    scaffoldBackgroundColor: Colors.grey[100], // Dezentes, neutrales Hintergrunddesign
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.teal, foregroundColor: Colors.white,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: Colors.teal[400]!, // Etwas hellere Variante für dunklen Modus
      secondary: Colors.amberAccent, // Akzentfarbe bleibt konsistent
      surface: Colors.grey[800]!, // Dunkler Hintergrund für Karten
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.black, // Dunkler Hintergrund für Fokus
    textTheme: TextTheme(
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal[200]),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.teal[400], foregroundColor: Colors.white,
    ),
  );
}
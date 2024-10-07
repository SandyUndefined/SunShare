import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: const Color(0xFFFFEB55), // Primary background color
      hintColor: const Color(0xFFFF8225), // Highlighter color
      scaffoldBackgroundColor: const Color(0xFFFFEB55), // Main background
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFFF8EDED)), // Text color
        bodyMedium: TextStyle(color: Color(0xFFF8EDED)),
        headlineSmall: TextStyle(color: Color(0xFFF8EDED)),
      ),
      appBarTheme: const AppBarTheme(
        color: Color(0xFF173B45),
        titleTextStyle: TextStyle(
          color: Color(0xFFF8EDED),
          fontSize: 20,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFFFF8225), // Text on button
        ),
      ),
    );
  }
}

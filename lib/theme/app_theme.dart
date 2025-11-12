import 'package:flutter/material.dart';

/// App-wide theme and color definitions
/// Provides consistent styling across the application
class AppTheme {
  // Color palette - inspired by Folderly design
  static const Color lavender = Color(0xFFE6D5F5);
  static const Color lightPink = Color(0xFFFFC9E3);
  static const Color lightBlue = Color(0xFFD5E8F5);
  static const Color lightGreen = Color(0xFFD5F5E6);
  static const Color yellow = Color(0xFFFFF59D);
  static const Color peach = Color(0xFFFFD5A3);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color.fromARGB(255, 221, 221, 221);
  static const Color labelGrey = Color.fromARGB(255, 100, 100, 100); // Darker grey for labels (NAME, SCHOOL, etc.)

  /// Main app theme configuration
  /// Uses Georgia serif font and bold black borders for distinctive look
  static ThemeData lightTheme = ThemeData(
    primaryColor: lavender,
    scaffoldBackgroundColor: white,
    fontFamily: 'Georgia', // Serif font for elegant look
    
    // AppBar styling - transparent with italic serif title
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: black),
      titleTextStyle: TextStyle(
        fontFamily: 'Georgia',
        fontSize: 32,
        fontStyle: FontStyle.italic,
        color: black,
      ),
    ),
    
    // Button styling - yellow background with black border
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: yellow,
        foregroundColor: black,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: black, width: 2),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // Input field styling - grey fill with black border
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: grey.withValues(alpha: 0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: black, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: black, width: 2),
      ),
    ),
  );
}
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// App-wide constants and reusable values
/// Centralizes spacing, radii, and common data
class K {
  // Spacing constants for consistent padding/margins
  static const double spacingXS = 6;
  static const double spacingS = 12;
  static const double spacingM = 16;
  static const double spacingL = 24;
  static const double spacingXL = 32;

  // Border radius constants for rounded corners
  static const double radiusS = 8;
  static const double radiusM = 12;
  static const double radiusL = 16;
  static const double radiusXL = 20;

  // Default emoji options for to-do items
  static const List<String> todoEmojis = ['📚', '💻', '🔬', '✏️', '📝', '🎨'];

  // Available color options for course folders and ID cards
  // Matches Folderly's color palette
  static const List<Color> folderColors = [
    AppTheme.lavender,
    AppTheme.lightPink,
    AppTheme.lightBlue,
    AppTheme.lightGreen,
    AppTheme.yellow,
    AppTheme.peach,
  ];
}



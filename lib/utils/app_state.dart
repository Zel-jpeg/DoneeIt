import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global app state manager using singleton pattern
/// Stores and persists user ID card information and preferences
class AppState extends ChangeNotifier {
  static final AppState instance = AppState._();
  AppState._();

  // ID card fields
  String name = '';
  String school = '';
  String yearLevel = '';
  DateTime? birthday;
  Color cardColor = const Color(0xFFE6D5F5); // Default: lavender
  String? profilePicturePath; // Path to saved profile picture file

  /// Updates ID card information
  /// Only updates provided fields, keeps existing values for others
  void setIdInfo({
    required String name,
    String? school,
    String? yearLevel,
    DateTime? birthday,
    Color? color,
  }) {
    this.name = name;
    this.school = school ?? this.school;
    this.yearLevel = yearLevel ?? this.yearLevel;
    this.birthday = birthday ?? this.birthday;
    if (color != null) cardColor = color;
    notifyListeners();
  }

  /// Loads saved data from SharedPreferences
  /// Called on app startup
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString('id_name') ?? '';
    school = prefs.getString('id_school') ?? '';
    yearLevel = prefs.getString('id_year') ?? '';
    final bdayMs = prefs.getInt('id_birthday');
    if (bdayMs != null) birthday = DateTime.fromMillisecondsSinceEpoch(bdayMs);
    final colorVal = prefs.getInt('id_color');
    if (colorVal != null) cardColor = Color(colorVal);
    profilePicturePath = prefs.getString('id_profile_picture');
    notifyListeners();
  }

  /// Saves current state to SharedPreferences
  /// Persists all ID card data for next app launch
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('id_name', name);
    await prefs.setString('id_school', school);
    await prefs.setString('id_year', yearLevel);
    if (birthday != null) await prefs.setInt('id_birthday', birthday!.millisecondsSinceEpoch);
    await prefs.setInt('id_color', cardColor.value);
    if (profilePicturePath != null) {
      await prefs.setString('id_profile_picture', profilePicturePath!);
    } else {
      await prefs.remove('id_profile_picture');
    }
  }

  /// Updates profile picture path and saves
  /// Automatically notifies listeners and persists changes
  void setProfilePicture(String? path) {
    profilePicturePath = path;
    notifyListeners();
    save();
  }
}



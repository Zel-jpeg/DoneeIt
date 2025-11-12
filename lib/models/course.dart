import 'package:flutter/material.dart';

/// Course model representing a course/folder
/// Contains basic course information and visual styling
class Course {
  final String id;
  final String name;
  final Color color;
  
  Course({
    required this.id,
    required this.name,
    required this.color,
  });
}
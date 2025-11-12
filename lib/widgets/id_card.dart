import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable ID card widget displaying user information
/// Shows profile picture, name, school, birthday, and year level
/// Supports tap actions for card and profile picture separately
class IDCard extends StatelessWidget {
  final Color color;
  final String name;
  final String school;
  final String birthday;
  final String yearLevel;
  final String? profilePicturePath;
  final VoidCallback? onProfilePictureTap;
  final VoidCallback? onTap;

  const IDCard({
    super.key,
    required this.color,
    required this.name,
    required this.school,
    required this.birthday,
    required this.yearLevel,
    this.profilePicturePath,
    this.onProfilePictureTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Tap entire card to edit
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.black, width: 3),
        ),
        child: Column(
        children: [
            // Top section: profile picture and name/school
            Row(
            children: [
              // Profile picture - clickable to change image
              GestureDetector(
                onTap: onProfilePictureTap,
                child: Container(
                  width: 80,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppTheme.black, width: 2),
                  ),
                  child: profilePicturePath != null && File(profilePicturePath!).existsSync()
                      ? Image.file(
                          File(profilePicturePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.add_a_photo, size: 36);
                          },
                        )
                      : const Icon(Icons.add_a_photo, size: 36),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    const Divider(thickness: 2, color: AppTheme.black),
                    const SizedBox(height: 8),
                    const Text('NAME', style: TextStyle(fontSize: 10, color: AppTheme.labelGrey)),
                    Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    const Text('SCHOOL', style: TextStyle(fontSize: 10, color: AppTheme.labelGrey)),
                    Text(school, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Bottom section: birthday and year level
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('BIRTHDAY', style: TextStyle(fontSize: 10, color: AppTheme.labelGrey)),
                Text(birthday, style: const TextStyle(fontSize: 12)),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('YEAR LEVEL', style: TextStyle(fontSize: 10, color: AppTheme.labelGrey)),
                Text(yearLevel, style: const TextStyle(fontSize: 12)),
              ]),
            ],
          ),
        ],
      ),
      ),
    );
  }
}



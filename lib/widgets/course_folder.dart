import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Course folder widget with folder-like design
/// Shows course name in a folder-style container with tab at top
/// Uses course color for background and styling
class CourseFolder extends StatelessWidget {
  final String name;
  final Color color;
  final VoidCallback? onTap;

  const CourseFolder({
    super.key,
    required this.name,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.black, width: 2),
        ),
        child: Stack(
          children: [
            // Folder tab at top
            Positioned(
              left: 16,
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.7),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  border: const Border(
                    left: BorderSide(color: AppTheme.black, width: 2),
                    right: BorderSide(color: AppTheme.black, width: 2),
                    bottom: BorderSide(color: AppTheme.black, width: 2),
                  ),
                ),
              ),
            ),
            // Course name label at bottom
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.black, width: 2),
                ),
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



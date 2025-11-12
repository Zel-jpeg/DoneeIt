import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable todo item widget
/// Displays icon, title, subtitle, and completion checkbox
/// Supports edit/delete actions via popup menu
/// Can be tapped to view description
class TodoItem extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle; // Course name or deadline info
  final bool completed;
  final String? description; // Todo description
  final ValueChanged<bool?>? onChanged; // Checkbox toggle callback
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap; // Tap callback to show details

  const TodoItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.completed,
    this.description,
    this.onChanged,
    this.onEdit,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.black, width: 2),
          ),
          child: Row(
            children: [
              // Emoji icon
              Text(icon, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 16),
              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: completed ? TextDecoration.lineThrough : TextDecoration.none,
                        decorationColor: Colors.black,
                        decorationThickness: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: completed ? Colors.green : Colors.grey,
                        decoration: completed ? TextDecoration.lineThrough : TextDecoration.none,
                        decorationColor: Colors.grey,
                        decorationThickness: 2,
                      ),
                    ),
                  ],
                ),
              ),
              // Actions: menu and checkbox
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Edit/Delete menu (only shown if callbacks provided)
                  if (onEdit != null || onDelete != null)
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 20),
                      onSelected: (value) {
                        if (value == 'edit' && onEdit != null) {
                          onEdit!();
                        } else if (value == 'delete' && onDelete != null) {
                          onDelete!();
                        }
                      },
                      itemBuilder: (context) => [
                        if (onEdit != null)
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 18),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                        if (onDelete != null)
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 18, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Delete', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  // Completion checkbox
                  Checkbox(
                    value: completed,
                    onChanged: onChanged,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



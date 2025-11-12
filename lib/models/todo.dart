/// Todo model representing a to-do item
/// Contains task information, deadline, and completion status
class Todo {
  final String id;
  final String title;
  final String course;
  final DateTime deadline;
  final String icon;
  bool isCompleted;
  
  Todo({
    required this.id,
    required this.title,
    required this.course,
    required this.deadline,
    required this.icon,
    this.isCompleted = false,
  });
}
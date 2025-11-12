import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/database/database_helper.dart';
import '../../widgets/todo_item.dart';
import '../../utils/constants.dart';

/// Screen showing details of a specific course
/// Displays course info and todos associated with this course
/// Supports edit/delete course and manage todos
class CourseDetailScreen extends StatefulWidget {
  final int courseId;
  final String courseName;
  final Color courseColor;
  final String? instructor;
  final String? room;

  const CourseDetailScreen({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.courseColor,
    this.instructor,
    this.room,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  final List<Map<String, dynamic>> _courseTodos = [];
  bool _isLoading = true;
  Map<String, dynamic>? _courseData;

  @override
  void initState() {
    super.initState();
    _loadCourseTodos();
    _loadCourseData();
  }

  /// Loads current course data from database
  Future<void> _loadCourseData() async {
    final course = await DatabaseHelper.instance.getCourse(widget.courseId);
    setState(() {
      _courseData = course;
    });
  }

  /// Loads todos that belong to this course
  Future<void> _loadCourseTodos() async {
    setState(() => _isLoading = true);
    final allTodos = await DatabaseHelper.instance.getTodos();
    setState(() {
      _courseTodos
        ..clear()
        ..addAll(allTodos.where((t) => t['courseId'] == widget.courseId));
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseName),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              if (value == 'edit') {
                await _loadCourseData();
                if (mounted && _courseData != null) {
                  _showEditCourseDialog(context);
                }
              } else if (value == 'delete') {
                _deleteCourse(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 18),
                    SizedBox(width: 8),
                    Text('Edit Course'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete Course', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course header card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: widget.courseColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.black, width: 3),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.courseName,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.instructor != null && widget.instructor!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.person, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                widget.instructor!,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                        if (widget.room != null && widget.room!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                widget.room!,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Course todos section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Course Tasks',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontStyle: FontStyle.italic,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        '${_courseTodos.length} tasks',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Todo list
                  if (_courseTodos.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Icon(
                              Icons.assignment_outlined,
                              size: 80,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No tasks for this course yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _courseTodos.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final todo = _courseTodos[index];
                        final deadline = todo['deadline'] as int?;
                        final subtitle = deadline == null
                            ? (todo['label'] ?? '')
                            : 'Due: ${DateTime.fromMillisecondsSinceEpoch(deadline).day}/${DateTime.fromMillisecondsSinceEpoch(deadline).month}/${DateTime.fromMillisecondsSinceEpoch(deadline).year}';

                        return TodoItem(
                          icon: todo['icon'] ?? '📌',
                          title: todo['title'] ?? '',
                          subtitle: subtitle,
                          completed: (todo['isCompleted'] ?? 0) == 1,
                          description: todo['description'] as String?,
                          onChanged: (val) async {
                            await DatabaseHelper.instance.updateTodoCompletion(
                              todo['id'] as int,
                              val == true,
                            );
                            await _loadCourseTodos();
                          },
                          onEdit: () => _showEditTodoDialog(context, todo),
                          onDelete: () => _deleteTodo(context, todo['id'] as int, todo['title'] as String),
                          onTap: () => _showTodoDetails(context, todo),
                        );
                      },
                    ),
                ],
              ),
            ),
    );
  }

  void _showEditCourseDialog(BuildContext context) {
    if (_courseData == null) return;
    
    final nameController = TextEditingController(text: _courseData!['name'] as String);
    final instructorController = TextEditingController(text: _courseData!['instructor'] as String? ?? '');
    final roomController = TextEditingController(text: _courseData!['room'] as String? ?? '');
    Color selectedColor = Color(_courseData!['color'] as int);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          final screenHeight = MediaQuery.of(context).size.height;
          final maxHeight = screenHeight * 0.9;
          
          return Container(
            constraints: BoxConstraints(maxHeight: maxHeight),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: keyboardHeight + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Edit Course',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(
                        color: selectedColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.black, width: 2),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 0,
                            top: 18,
                            child: Container(
                              width: 140,
                              height: 28,
                              decoration: BoxDecoration(
                                color: selectedColor.withValues(alpha: 0.6),
                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12)),
                                border: const Border(
                                  left: BorderSide(color: AppTheme.black, width: 2),
                                  bottom: BorderSide(color: AppTheme.black, width: 2),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      onChanged: (_) => setModalState(() {}),
                      decoration: const InputDecoration(
                        labelText: 'Course Name',
                        hintText: 'e.g., Mathematics',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Color', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: K.folderColors.map((color) {
                        return GestureDetector(
                          onTap: () => setModalState(() => selectedColor = color),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selectedColor == color ? AppTheme.black : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            child: selectedColor == color
                                ? const Icon(Icons.check, color: AppTheme.black)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text('Instructor'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: instructorController,
                      decoration: const InputDecoration(
                        hintText: "Enter instructor's name (Optional)",
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Room Location'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: roomController,
                      decoration: const InputDecoration(
                        hintText: 'Enter room location (Optional)',
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: nameController.text.isEmpty
                            ? null
                            : () async {
                                await DatabaseHelper.instance.updateCourse(widget.courseId, {
                                  'name': nameController.text,
                                  'color': selectedColor.value,
                                  'instructor': instructorController.text,
                                  'room': roomController.text,
                                });
                                if (mounted) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              },
                        child: const Text('Update Course'),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _deleteCourse(BuildContext context) async {
    // Check if course has ongoing todos
    final hasOngoing = await DatabaseHelper.instance.hasOngoingTodos(widget.courseId);
    if (hasOngoing) {
      if (mounted) {
        final ongoingCount = await DatabaseHelper.instance.getOngoingTodosCount(widget.courseId);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.red, width: 2),
            ),
            title: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red[700], size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Cannot Delete Course',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cannot delete "${widget.courseName}" because it has $ongoingCount ongoing ${ongoingCount == 1 ? 'todo' : 'todos'}.',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Please complete or delete all ongoing todos before deleting this course.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.black,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Course'),
        content: Text('Are you sure you want to delete "${widget.courseName}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DatabaseHelper.instance.deleteCourse(widget.courseId);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course deleted successfully')),
        );
      }
    }
  }

  void _showEditTodoDialog(BuildContext context, Map<String, dynamic> todo) async {
    final todoId = todo['id'] as int;
    final TextEditingController titleController = TextEditingController(text: todo['title'] as String? ?? '');
    final TextEditingController descriptionController = TextEditingController(text: todo['description'] as String? ?? '');
    
    // Determine label type and values
    final label = todo['label'] as String? ?? '';
    final courseId = todo['courseId'] as int?;
    String selectedLabelType = courseId != null ? 'Course' : 'Custom';
    String selectedCustomLabel = courseId == null && label.isNotEmpty ? label : 'Homework';
    int? selectedCourseId = courseId;
    String? selectedCourseName;
    final courses = await DatabaseHelper.instance.getCourses();
    if (selectedCourseId != null) {
      final course = courses.firstWhere((c) => c['id'] == selectedCourseId, orElse: () => {});
      selectedCourseName = course['name'] as String?;
    }
    
    // Parse deadline
    DateTime? selectedDeadline;
    TimeOfDay? selectedTime;
    bool setDeadline = false;
    if (todo['deadline'] != null) {
      final deadlineMs = todo['deadline'] as int;
      selectedDeadline = DateTime.fromMillisecondsSinceEpoch(deadlineMs);
      selectedTime = TimeOfDay.fromDateTime(selectedDeadline);
      setDeadline = true;
    }
    
    String selectedIcon = todo['icon'] as String? ?? '📌';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          final screenHeight = MediaQuery.of(context).size.height;
          final maxHeight = screenHeight * 0.9;
          
          return Container(
            constraints: BoxConstraints(maxHeight: maxHeight),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: keyboardHeight + 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Edit To-do',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Center(
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppTheme.black, width: 2),
                              ),
                              child: Center(
                                child: Text(selectedIcon, style: const TextStyle(fontSize: 40)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text('To-do'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: titleController,
                            onChanged: (_) => setModalState(() {}),
                            decoration: const InputDecoration(hintText: 'Enter to-do'),
                          ),
                          const SizedBox(height: 16),
                          const Text('Icon'),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: 80,
                            child: TextField(
                              textAlign: TextAlign.center,
                              maxLength: 2,
                              decoration: const InputDecoration(counterText: ''),
                              controller: TextEditingController(text: selectedIcon),
                              onChanged: (v) => setModalState(() {
                                if (v.isNotEmpty) selectedIcon = v.characters.first;
                              }),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: K.todoEmojis.map((icon) {
                              return GestureDetector(
                                onTap: () => setModalState(() => selectedIcon = icon),
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: selectedIcon == icon ? AppTheme.yellow : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: selectedIcon == icon ? AppTheme.black : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(child: Text(icon, style: const TextStyle(fontSize: 22))),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                          const Text('Label'),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setModalState(() => selectedLabelType = 'Custom'),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: selectedLabelType == 'Custom' ? AppTheme.yellow : Colors.white,
                                      border: Border.all(color: AppTheme.black, width: 2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(child: Text('Custom')),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setModalState(() => selectedLabelType = 'Course'),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: selectedLabelType == 'Course' ? AppTheme.yellow : Colors.white,
                                      border: Border.all(color: AppTheme.black, width: 2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(child: Text('Course')),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (selectedLabelType == 'Custom')
                            DropdownButtonFormField<String>(
                              value: selectedCustomLabel,
                              decoration: const InputDecoration(hintText: 'Select a custom label'),
                              items: const [
                                DropdownMenuItem(value: 'Homework', child: Text('Homework')),
                                DropdownMenuItem(value: 'Project', child: Text('Project')),
                                DropdownMenuItem(value: 'Review', child: Text('Review')),
                              ],
                              onChanged: (v) => setModalState(() => selectedCustomLabel = v ?? 'Homework'),
                            )
                          else
                            DropdownButtonFormField<int>(
                              value: selectedCourseId,
                              decoration: const InputDecoration(hintText: 'Select course'),
                              items: courses
                                  .map((c) => DropdownMenuItem(
                                        value: c['id'] as int,
                                        child: Text(c['name'] as String),
                                      ))
                                  .toList(),
                              onChanged: (v) => setModalState(() {
                                selectedCourseId = v;
                                selectedCourseName = courses.firstWhere((e) => e['id'] == v)['name'] as String;
                              }),
                            ),
                          const SizedBox(height: 20),
                          const Text('Description'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: descriptionController,
                            maxLines: 3,
                            decoration: const InputDecoration(hintText: 'Add description'),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Set Deadline'),
                              Switch(
                                value: setDeadline,
                                onChanged: (v) => setModalState(() => setDeadline = v),
                              ),
                            ],
                          ),
                          if (setDeadline) ...[
                            const SizedBox(height: 6),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.calendar_today),
                              title: Text(selectedDeadline == null
                                  ? 'Pick a date'
                                  : '${selectedDeadline!.day}/${selectedDeadline!.month}/${selectedDeadline!.year}'),
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDeadline ?? DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                                if (date != null) {
                                  setModalState(() {
                                    selectedDeadline = date;
                                    if (selectedTime != null) {
                                      selectedDeadline = DateTime(
                                        date.year,
                                        date.month,
                                        date.day,
                                        selectedTime!.hour,
                                        selectedTime!.minute,
                                      );
                                    }
                                  });
                                }
                              },
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.access_time),
                              title: Text(selectedTime == null
                                  ? 'Pick a time'
                                  : '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'),
                              onTap: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: selectedTime ?? TimeOfDay.now(),
                                );
                                if (time != null) {
                                  setModalState(() {
                                    selectedTime = time;
                                    if (selectedDeadline != null) {
                                      selectedDeadline = DateTime(
                                        selectedDeadline!.year,
                                        selectedDeadline!.month,
                                        selectedDeadline!.day,
                                        time.hour,
                                        time.minute,
                                      );
                                    }
                                  });
                                }
                              },
                            ),
                          ],
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: titleController.text.isEmpty
                            ? null
                            : () async {
                                await DatabaseHelper.instance.updateTodo(todoId, {
                                  'title': titleController.text,
                                  'label': selectedLabelType == 'Custom' ? selectedCustomLabel : (selectedCourseName ?? ''),
                                  'courseId': selectedCourseId,
                                  'description': descriptionController.text,
                                  'deadline': setDeadline && selectedDeadline != null
                                      ? selectedDeadline!.millisecondsSinceEpoch
                                      : null,
                                  'icon': selectedIcon,
                                });
                                if (mounted) {
                                  Navigator.pop(context);
                                  await _loadCourseTodos();
                                }
                              },
                        child: const Text('Update To-do'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _deleteTodo(BuildContext context, int id, String title) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete To-do'),
        content: Text('Are you sure you want to delete "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DatabaseHelper.instance.deleteTodo(id);
      if (mounted) {
        await _loadCourseTodos();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('To-do deleted successfully')),
        );
      }
    }
  }

  /// Shows todo details dialog with description
  void _showTodoDetails(BuildContext context, Map<String, dynamic> todo) {
    final icon = todo['icon'] ?? '📌';
    final title = todo['title'] ?? '';
    final description = todo['description'] as String? ?? '';
    final label = todo['label'] as String? ?? '';
    final deadline = todo['deadline'] as int?;
    final completed = (todo['isCompleted'] ?? 0) == 1;

    String deadlineText = '';
    if (deadline != null) {
      final deadlineDate = DateTime.fromMillisecondsSinceEpoch(deadline);
      deadlineText = '${deadlineDate.day}/${deadlineDate.month}/${deadlineDate.year} ${deadlineDate.hour.toString().padLeft(2, '0')}:${deadlineDate.minute.toString().padLeft(2, '0')}';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.black, width: 2),
        ),
        title: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: completed ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (label.isNotEmpty) ...[
                  Row(
                    children: [
                      const Icon(Icons.label_outline, size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          label,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                if (deadlineText.isNotEmpty) ...[
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Due: $deadlineText',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                if (description.isNotEmpty) ...[
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(
                      minHeight: 60,
                      maxHeight: 300,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        description,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ] else
                  const Text(
                    'No description',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'Close',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
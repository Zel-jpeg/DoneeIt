import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';
import '../../core/database/database_helper.dart';
import 'course_detail_screen.dart';

/// Screen displaying list of all courses
/// Shows course folders in a grid, supports add/edit/delete operations
class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State {
  final List<Map<String, dynamic>> _courses = [];

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  /// Loads all courses from database
  Future<void> _loadCourses() async {
    final rows = await DatabaseHelper.instance.getCourses();
    setState(() {
      _courses
        ..clear()
        ..addAll(rows);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: _courses.isEmpty ? _buildEmptyState() : _buildCourseList(),
      floatingActionButton: _courses.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(bottom: 8, right: 8),
              child: ElevatedButton.icon(
                onPressed: () => _showAddCourseDialog(context),
                icon: const Icon(Icons.add, color: AppTheme.black),
                label: const Text(
                  'Add Course',
                  style: TextStyle(
                    color: AppTheme.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.yellow,
                  foregroundColor: AppTheme.black,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: AppTheme.black, width: 2),
                  ),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_outlined,
            size: 120,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          const Text(
            'No courses found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () => _showAddCourseDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Course'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.yellow,
              foregroundColor: AppTheme.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseList() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: _courses.length,
        itemBuilder: (context, index) {
          final course = _courses[index];
          final colorVal = (course['color'] as int?) ?? AppTheme.lavender.value;
          return _buildCourseFolder(
            course['id'] as int,
            course['name'] as String,
            Color(colorVal),
            course['instructor'] as String?,
            course['room'] as String?,
          );
        },
      ),
    );
  }

  Widget _buildCourseFolder(
    int id,
    String name,
    Color color,
    String? instructor,
    String? room,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CourseDetailScreen(
              courseId: id,
              courseName: name,
              courseColor: color,
              instructor: instructor,
              room: room,
            ),
          ),
        ).then((_) => _loadCourses());
      },
      onLongPress: () {
        _showCourseOptions(context, id, name, color, instructor, room);
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.black, width: 2),
        ),
        child: Stack(
          children: [
            // Folder tab
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
            
            // Label
            Positioned(
              left: 16,
              bottom: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.black, width: 2),
                ),
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCourseDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController instructorController = TextEditingController();
    final TextEditingController roomController = TextEditingController();
    Color selectedColor = AppTheme.lavender;
    bool assignSchedules = false;

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
            constraints: BoxConstraints(
              maxHeight: maxHeight,
            ),
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
                  // Handle bar
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
                    'Add New Course',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 12),

                  // Folder preview
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
                        // tab
                        Positioned(
                          right: 0,
                          top: 18,
                          child: Container(
                            width: 140,
                            height: 28,
                            decoration: BoxDecoration(
                              color: selectedColor.withValues(alpha: 0.6),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                              ),
                              border: const Border(
                                left: BorderSide(color: AppTheme.black, width: 2),
                                bottom: BorderSide(color: AppTheme.black, width: 2),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          bottom: 16,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppTheme.black, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Course name
                  TextField(
                    controller: nameController,
                    onChanged: (_) => setModalState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Course Name',
                      hintText: 'e.g., Mathematics',
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  const Text(
                    'Color',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Color picker
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: K.folderColors.map((color) {
                      return GestureDetector(
                        onTap: () {
                          setModalState(() => selectedColor = color);
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedColor == color
                                  ? AppTheme.black
                                  : Colors.transparent,
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

                  // Instructor (optional)
                  const Text('Instructor'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: instructorController,
                    decoration: const InputDecoration(
                      hintText: "Enter instructor's name (Optional)",
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Room (optional)
                  const Text('Room Location'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: roomController,
                    decoration: const InputDecoration(
                      hintText: 'Enter room location (Optional)',
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Assign schedules switch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Assign schedules to this course'),
                      Switch(
                        value: assignSchedules,
                        onChanged: (v) => setModalState(() => assignSchedules = v),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  
                  // Add button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: nameController.text.isEmpty
                          ? null
                          : () async {
                              await DatabaseHelper.instance.insertCourse({
                                'name': nameController.text,
                                'color': selectedColor.value,
                                'instructor': instructorController.text,
                                'room': roomController.text,
                              });
                              if (mounted) {
                                Navigator.pop(context);
                                await _loadCourses();
                              }
                            },
                      child: const Text('Add Course'),
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

  void _showCourseOptions(
    BuildContext context,
    int id,
    String name,
    Color color,
    String? instructor,
    String? room,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Course'),
              onTap: () {
                Navigator.pop(context);
                _showEditCourseDialog(context, id, name, color, instructor, room);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Course', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteCourse(context, id, name);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditCourseDialog(
    BuildContext context,
    int courseId,
    String currentName,
    Color currentColor,
    String? currentInstructor,
    String? currentRoom,
  ) {
    final TextEditingController nameController = TextEditingController(text: currentName);
    final TextEditingController instructorController = TextEditingController(text: currentInstructor ?? '');
    final TextEditingController roomController = TextEditingController(text: currentRoom ?? '');
    Color selectedColor = currentColor;
    bool assignSchedules = false;

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
            constraints: BoxConstraints(
              maxHeight: maxHeight,
            ),
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
                    // Handle bar
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
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 12),

                    // Folder preview
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
                          // tab
                          Positioned(
                            right: 0,
                            top: 18,
                            child: Container(
                              width: 140,
                              height: 28,
                              decoration: BoxDecoration(
                                color: selectedColor.withValues(alpha: 0.6),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                ),
                                border: const Border(
                                  left: BorderSide(color: AppTheme.black, width: 2),
                                  bottom: BorderSide(color: AppTheme.black, width: 2),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 16,
                            bottom: 16,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppTheme.black, width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Course name
                    TextField(
                      controller: nameController,
                      onChanged: (_) => setModalState(() {}),
                      decoration: const InputDecoration(
                        labelText: 'Course Name',
                        hintText: 'e.g., Mathematics',
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    const Text(
                      'Color',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Color picker
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: K.folderColors.map((color) {
                        return GestureDetector(
                          onTap: () {
                            setModalState(() => selectedColor = color);
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selectedColor == color
                                    ? AppTheme.black
                                    : Colors.transparent,
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

                    // Instructor (optional)
                    const Text('Instructor'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: instructorController,
                      decoration: const InputDecoration(
                        hintText: "Enter instructor's name (Optional)",
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Room (optional)
                    const Text('Room Location'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: roomController,
                      decoration: const InputDecoration(
                        hintText: 'Enter room location (Optional)',
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Assign schedules switch
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Assign schedules to this course'),
                        Switch(
                          value: assignSchedules,
                          onChanged: (v) => setModalState(() => assignSchedules = v),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    
                    // Update button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: nameController.text.isEmpty
                            ? null
                            : () async {
                                await DatabaseHelper.instance.updateCourse(courseId, {
                                  'name': nameController.text,
                                  'color': selectedColor.value,
                                  'instructor': instructorController.text,
                                  'room': roomController.text,
                                });
                                if (mounted) {
                                  Navigator.pop(context);
                                  await _loadCourses();
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

  Future<void> _deleteCourse(BuildContext context, int id, String name) async {
    // Check if course has ongoing todos
    final hasOngoing = await DatabaseHelper.instance.hasOngoingTodos(id);
    if (hasOngoing) {
      if (mounted) {
        final ongoingCount = await DatabaseHelper.instance.getOngoingTodosCount(id);
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
                  'Cannot delete "$name" because it has $ongoingCount ongoing ${ongoingCount == 1 ? 'todo' : 'todos'}.',
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
        content: Text('Are you sure you want to delete "$name"? This action cannot be undone.'),
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
      await DatabaseHelper.instance.deleteCourse(id);
      if (mounted) {
        await _loadCourses();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course deleted successfully')),
        );
      }
    }
  }
}
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../courses/courses_screen.dart';
import '../profile/profile_screen.dart';
import '../settings/settings_screen.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';
import '../../utils/app_state.dart';
import '../../widgets/id_card.dart';
import '../../core/database/database_helper.dart';
import '../../widgets/todo_item.dart';
import '../profile/edit_id_screen.dart';

/// Main home screen with bottom navigation
/// Displays ID card, todos, and navigation to other screens
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final GlobalKey<_HomeContentState> _homeKey = GlobalKey<_HomeContentState>();

  final List<Widget> _screens = const [
    SizedBox.shrink(), // Home content is built separately
    CoursesScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  /// Shows dialog to add a new todo item
  void _showAddTodoDialog(BuildContext context) async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    String selectedLabelType = 'Custom'; // or 'Course'
    String selectedCustomLabel = 'Homework';
    int? selectedCourseId;
    String? selectedCourseName;
    final courses = await DatabaseHelper.instance.getCourses();
    DateTime? selectedDeadline;
    TimeOfDay? selectedTime;
    bool setDeadline = false;
    String selectedIcon = '📌';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    'New To-do',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 8),

                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 12),
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
                            decoration: const InputDecoration(hintText: 'Enter to-do'),
                          ),

                          const SizedBox(height: 16),
                          // Emoji input (device keyboard)
                          const Text('Icon'),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: 80,
                            child: TextField(
                              textAlign: TextAlign.center,
                              maxLength: 2,
                              decoration: const InputDecoration(counterText: ''),
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
                              initialValue: selectedCustomLabel,
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
                              initialValue: selectedCourseId,
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
                              Switch(value: setDeadline, onChanged: (v) => setModalState(() => setDeadline = v)),
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
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                                if (date != null) setModalState(() => selectedDeadline = date);
                              },
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.access_time),
                              title: Text(selectedTime == null
                                  ? 'Pick a time'
                                  : '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'),
                              onTap: () async {
                                final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                                if (time != null) setModalState(() => selectedTime = time);
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Fixed bottom button
                  SafeArea(
                    top: false,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: titleController.text.isEmpty
                            ? null
                            : () async {
                                await DatabaseHelper.instance.insertTodo({
                                  'title': titleController.text,
                                  'label': selectedLabelType == 'Custom' ? selectedCustomLabel : (selectedCourseName ?? ''),
                                  'courseId': selectedCourseId,
                                  'description': descriptionController.text,
                                  'deadline': selectedDeadline?.millisecondsSinceEpoch,
                                  'icon': selectedIcon,
                                  'isCompleted': 0,
                                });
                                if (mounted) {
                                  Navigator.pop(context);
                                  _homeKey.currentState?.loadTodos();
                                }
                              },
                        child: const Text('Create'),
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

  Future<void> _pickProfilePicture(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    
    // Show options: Camera or Gallery
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                AppState.instance.setProfilePicture(null);
              },
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    try {
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image != null) {
        // Get app documents directory
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String appDocPath = appDocDir.path;
        
        // Create profile_pictures directory if it doesn't exist
        final Directory profilePicsDir = Directory('$appDocPath/profile_pictures');
        if (!await profilePicsDir.exists()) {
          await profilePicsDir.create(recursive: true);
        }

        // Copy image to app directory with a unique name
        final String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}${path.extension(image.path)}';
        final String savedPath = path.join(profilePicsDir.path, fileName);
        
        final File savedFile = await File(image.path).copy(savedPath);
        
        // Delete old profile picture if exists
        final oldPath = AppState.instance.profilePicturePath;
        if (oldPath != null && File(oldPath).existsSync()) {
          try {
            await File(oldPath).delete();
          } catch (e) {
            // Ignore deletion errors
          }
        }

        // Save new path
        AppState.instance.setProfilePicture(savedFile.path);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile picture updated!')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0
          ? HomeContent(
              key: _homeKey,
              onAddTodo: () => _showAddTodoDialog(context),
              onPickProfilePicture: () => _pickProfilePicture(context),
            )
          : _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  final VoidCallback onAddTodo;
  final VoidCallback onPickProfilePicture;
  const HomeContent({
    super.key,
    required this.onAddTodo,
    required this.onPickProfilePicture,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _filter = 'Ongoing';
  final List<String> _filters = const ['Ongoing', 'Completed', 'Missed'];
  final List<Map<String, dynamic>> _todos = [];

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  Future<void> loadTodos() async {
    final rows = await DatabaseHelper.instance.getTodos();
    setState(() {
      _todos
        ..clear()
        ..addAll(rows);
    });
  }

  List<Map<String, dynamic>> get _visibleTodos {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    if (_filter == 'Completed') {
      return _todos.where((t) => (t['isCompleted'] ?? 0) == 1).toList();
    }
    if (_filter == 'Missed') {
      return _todos.where((t) => (t['isCompleted'] ?? 0) == 0 && (t['deadline'] ?? nowMs + 1) < nowMs).toList();
    }
    // Ongoing
    return _todos.where((t) => (t['isCompleted'] ?? 0) == 0 && ((t['deadline'] ?? nowMs + 1) >= nowMs)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed header section
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header - Now uses AppState
            AnimatedBuilder(
              animation: AppState.instance,
              builder: (context, _) {
                final name = AppState.instance.name.isEmpty ? 'User' : AppState.instance.name;
                final now = DateTime.now();
                final formattedDate = DateFormat('EEEE, MMMM d').format(now);
                
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, $name',
                          style: const TextStyle(
                            fontFamily: 'Georgia',
                            fontStyle: FontStyle.italic,
                            fontSize: 32,
                          ),
                        ),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            
            const SizedBox(height: 30),
            
            // ID Card (clickable, driven by AppState)
            AnimatedBuilder(
              animation: AppState.instance,
              builder: (context, _) {
                final s = AppState.instance;
                    return IDCard(
                    color: s.cardColor,
                    name: s.name.isEmpty ? 'Your Name' : s.name,
                    school: s.school.isEmpty ? '—' : s.school,
                    birthday: s.birthday == null
                        ? '—'
                        : '${s.birthday!.month}-${s.birthday!.day}-${s.birthday!.year}',
                    yearLevel: s.yearLevel.isEmpty ? '—' : s.yearLevel,
                      profilePicturePath: s.profilePicturePath,
                      onProfilePictureTap: widget.onPickProfilePicture,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const EditIDScreen()),
                        );
                      },
                );
              },
            ),
            
            const SizedBox(height: 30),
            
                // To-do section header with dropdown filter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'To-do',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontStyle: FontStyle.italic,
                    fontSize: 24,
                  ),
                ),
                Row(
                  children: [
                    Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.black, width: 2),
                      ),
                          child: PopupMenuButton<String>(
                            initialValue: _filter,
                            onSelected: (value) => setState(() => _filter = value),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _filter,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.keyboard_arrow_down, size: 20),
                              ],
                            ),
                            itemBuilder: (context) => _filters.map((filter) {
                              return PopupMenuItem<String>(
                                value: filter,
                                child: Row(
                                  children: [
                                    if (_filter == filter)
                                      const Icon(Icons.check, size: 18, color: AppTheme.yellow)
                                    else
                                      const SizedBox(width: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      filter,
                                      style: TextStyle(
                                        fontWeight: _filter == filter ? FontWeight.w700 : FontWeight.normal,
                                        color: _filter == filter ? AppTheme.black : Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: widget.onAddTodo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: AppTheme.black, width: 2),
                        ),
                      ),
                      child: const Text('+ To-do'),
                    ),
                  ],
                ),
              ],
                ),
              ],
            ),
            ),
            
            const SizedBox(height: 20),
            
          // Scrollable todo list section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _visibleTodos.isEmpty
                  ? Center(
                child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.assignment_outlined, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No tasks to accomplish', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              )
                  : ListView.separated(
                itemCount: _visibleTodos.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final t = _visibleTodos[index];
                  final deadline = t['deadline'] as int?;
                  final subtitle = deadline == null
                      ? (t['label'] ?? '')
                      : '${t['label'] ?? ''} | ${DateTime.fromMillisecondsSinceEpoch(deadline).day}/${DateTime.fromMillisecondsSinceEpoch(deadline).month}/${DateTime.fromMillisecondsSinceEpoch(deadline).year}';
                  return TodoItem(
                    icon: t['icon'] ?? '📌',
                    title: t['title'] ?? '',
                    subtitle: subtitle,
                    completed: (t['isCompleted'] ?? 0) == 1,
                          description: t['description'] as String?,
                    onChanged: (val) async {
                      await DatabaseHelper.instance.updateTodoCompletion(t['id'] as int, val == true);
                      await loadTodos();
                    },
                          onEdit: () => _showEditTodoDialog(context, t),
                          onDelete: () => _deleteTodo(context, t['id'] as int, t['title'] as String),
                          onTap: () => _showTodoDetails(context, t),
                  );
                },
                    ),
            ),
              ),
          ],
        ),
    );
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
                    'Edit To-do',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 8),

                  // Scrollable content
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
                              initialValue: selectedCustomLabel,
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
                              initialValue: selectedCourseId,
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

                  // Fixed bottom button
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
                                  loadTodos();
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
        await loadTodos();
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
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            minWidth: MediaQuery.of(context).size.width * 0.8,
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
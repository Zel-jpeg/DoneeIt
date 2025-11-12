import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';
import '../../utils/app_state.dart';
import '../home/home_screen.dart';

/// Screen for editing ID card information
/// Allows user to set name, school, birthday, year level, color, and profile picture
class EditIDScreen extends StatefulWidget {
  const EditIDScreen({super.key});

  @override
  State<EditIDScreen> createState() => _EditIDScreenState();
}

class _EditIDScreenState extends State<EditIDScreen> {
  Color selectedColor = AppTheme.lavender;
  String? selectedLogo;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController schoolController = TextEditingController();
  final TextEditingController yearLevelController = TextEditingController();
  DateTime? birthday;
  String? profilePicturePath;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  /// Loads existing ID card data from AppState
  /// Pre-fills form fields with current values
  void _loadExistingData() {
    final state = AppState.instance;
    nameController.text = state.name;
    schoolController.text = state.school;
    yearLevelController.text = state.yearLevel;
    birthday = state.birthday;
    selectedColor = state.cardColor;
    profilePicturePath = state.profilePicturePath;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit ID')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.black, width: 3),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _pickProfilePicture(context),
                      child: Container(
                        width: 90,
                        height: 110,
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
                          const SizedBox(height: 8),
                          const Divider(thickness: 2, color: AppTheme.black),
                          const SizedBox(height: 8),
                          const Text('NAME', style: TextStyle(fontSize: 10, color: AppTheme.labelGrey)),
                          Text(
                            nameController.text.isEmpty ? '—' : nameController.text,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          const Text('SCHOOL', style: TextStyle(fontSize: 10, color: AppTheme.labelGrey)),
                          Text(
                            schoolController.text.isEmpty ? '—' : schoolController.text,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                const Text('BIRTHDAY', style: TextStyle(fontSize: 10, color: AppTheme.labelGrey)),
                                Text(birthday == null ? '—' : '${birthday!.month}-${birthday!.day}-${birthday!.year}', style: const TextStyle(fontSize: 12)),
                              ]),
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                const Text('YEAR LEVEL', style: TextStyle(fontSize: 10, color: AppTheme.labelGrey)),
                                Text(
                                  yearLevelController.text.isEmpty ? '—' : yearLevelController.text,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Text('Color'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                children: K.folderColors.map((c) {
                  return GestureDetector(
                    onTap: () => setState(() => selectedColor = c),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedColor == c ? AppTheme.black : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),
              const Text('Name'),
              const SizedBox(height: 6),
              TextField(
                controller: nameController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(hintText: 'Enter your name'),
              ),

              const SizedBox(height: 16),
              const Text('School'),
              const SizedBox(height: 6),
              TextField(
                controller: schoolController,
                decoration: const InputDecoration(hintText: 'Enter your school (optional)'),
              ),

              const SizedBox(height: 16),
              const Text('Year Level'),
              const SizedBox(height: 6),
              TextField(
                controller: yearLevelController,
                decoration: const InputDecoration(hintText: 'Enter your year level (optional)'),
              ),

              const SizedBox(height: 16),
              const Text('Birthday'),
              const SizedBox(height: 6),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: birthday ?? DateTime(2000, 1, 1),
                    firstDate: DateTime(1970),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => birthday = picked);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.black, width: 2),
                  ),
                  child: Text(birthday == null ? 'Tap to select birthday' : '${birthday!.month}-${birthday!.day}-${birthday!.year}'),
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Save to simple app state
                    AppState.instance.setIdInfo(
                      name: nameController.text,
                      birthday: birthday,
                      color: selectedColor,
                      school: schoolController.text.isEmpty ? null : schoolController.text,
                      yearLevel: yearLevelController.text.isEmpty ? null : yearLevelController.text,
                    );
                    AppState.instance.setProfilePicture(profilePicturePath);
                    AppState.instance.save();
                    
                    // If we can't pop (coming from onboarding), navigate to HomeScreen
                    // Otherwise, just pop back to previous screen
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickProfilePicture(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    
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
            if (profilePicturePath != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    profilePicturePath = null;
                  });
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
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String appDocPath = appDocDir.path;
        final Directory profilePicsDir = Directory('$appDocPath/profile_pictures');
        if (!await profilePicsDir.exists()) {
          await profilePicsDir.create(recursive: true);
        }

        final String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}${path.extension(image.path)}';
        final String savedPath = path.join(profilePicsDir.path, fileName);
        final File savedFile = await File(image.path).copy(savedPath);
        
        final oldPath = profilePicturePath;
        if (oldPath != null && File(oldPath).existsSync()) {
          try {
            await File(oldPath).delete();
          } catch (e) {
            // Ignore deletion errors
          }
        }

        setState(() {
          profilePicturePath = savedFile.path;
        });
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: ${e.toString()}')),
        );
      }
    }
  }
}



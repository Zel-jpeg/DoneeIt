import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import 'edit_id_screen.dart';

/// Profile screen displaying user information
/// Shows ID card data, profile picture, and allows editing
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditIDScreen()),
              );
            },
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: AppState.instance,
        builder: (context, _) {
          final state = AppState.instance;
          final name = state.name.isEmpty ? 'User' : state.name;
          final school = state.school.isEmpty ? 'Not set' : state.school;
          final yearLevel = state.yearLevel.isEmpty ? 'Not set' : state.yearLevel;
          final birthday = state.birthday == null
              ? 'Not set'
              : '${state.birthday!.month.toString().padLeft(2, '0')}-${state.birthday!.day.toString().padLeft(2, '0')}-${state.birthday!.year}';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Profile Picture
                GestureDetector(
                  onTap: () => _pickProfilePicture(context),
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: state.cardColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.black, width: 3),
                        ),
                        child: state.profilePicturePath != null &&
                                File(state.profilePicturePath!).existsSync()
                            ? ClipOval(
                                child: Image.file(
                                  File(state.profilePicturePath!),
                                  fit: BoxFit.cover,
                                  width: 120,
                                  height: 120,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.person, size: 60);
                                  },
                                ),
                              )
                            : const Icon(Icons.person, size: 60),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.yellow,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppTheme.black, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                Text(
                  name.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                /*
                Text(
                  school,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                */
                const SizedBox(height: 30),
                
                // Info Cards
                _buildInfoCard(
                  icon: Icons.school,
                  label: 'Year Level',
                  value: yearLevel,
                  color: state.cardColor,
                ),
                
                const SizedBox(height: 16),
                
                _buildInfoCard(
                  icon: Icons.cake,
                  label: 'Birthday',
                  value: birthday,
                  color: state.cardColor,
                ),
                
                const SizedBox(height: 16),
                
                _buildInfoCard(
                  icon: Icons.location_city,
                  label: 'School',
                  value: school,
                  color: state.cardColor,
                ),
              ],
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

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.black, width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.black),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
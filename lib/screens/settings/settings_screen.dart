import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/id_card.dart';
import '../profile/edit_id_screen.dart';

/// Settings screen with app preferences and options
/// Shows ID card preview and various settings sections
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = AppState.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: AnimatedBuilder(
        animation: appState,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- ID CARD PREVIEW ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: IDCard(
                    color: appState.cardColor,
                    name: appState.name.isEmpty ? 'Your Name' : appState.name,
                    school: appState.school.isEmpty ? '—' : appState.school,
                    birthday: appState.birthday == null
                        ? '—'
                        : '${appState.birthday!.month}-${appState.birthday!.day}-${appState.birthday!.year}',
                    yearLevel: appState.yearLevel.isEmpty ? '—' : appState.yearLevel,
                    profilePicturePath: appState.profilePicturePath,
                    onProfilePictureTap: () => _pickProfilePicture(context),
                  ),
                ),

            const SizedBox(height: 24),

            // --- GENERAL SETTINGS ---
            _sectionTitle('General'),
            _settingsList([
              _settingsItem(
                icon: Icons.notifications_outlined,
                title: 'Request notifications',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifications coming soon!')),
                  );
                },
              ),
              _settingsItem(
                icon: Icons.report_problem_outlined,
                title: 'Report a problem',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Report feature coming soon!')),
                  );
                },
              ),
              _settingsItem(
                icon: Icons.lightbulb_outline,
                title: 'Request a feature',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Feature request coming soon!')),
                  );
                },
              ),
            ]),

            const SizedBox(height: 30),

            // --- ID CARD SETTINGS ---
            _sectionTitle('ID Card'),
            _settingsList([
              _settingsItem(
                icon: Icons.edit_outlined,
                title: 'Edit ID Card',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditIDScreen()),
                  );
                },
              ),
              _settingsItem(
                icon: Icons.upload_outlined,
                title: 'Export ID Card',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Export ID Card coming soon!')),
                  );
                },
              ),
            ]),

            const SizedBox(height: 30),

            // --- TO-DO SETTINGS ---
            _sectionTitle('To-do'),
            _settingsList([
              _settingsItem(
                icon: Icons.emoji_emotions_outlined,
                title: 'Default to-do icon',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Default icon setting coming soon!')),
                  );
                },
                trailing: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('📌'),
                ),
              ),
            ]),
          ],
        ),
      );
        },
      ),
    );
  }

  Future<void> _pickProfilePicture(BuildContext context) async {
    // Get the HomeScreen's pickProfilePicture method
    // We'll need to access it through a callback or create a shared method
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
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String appDocPath = appDocDir.path;
        final Directory profilePicsDir = Directory('$appDocPath/profile_pictures');
        if (!await profilePicsDir.exists()) {
          await profilePicsDir.create(recursive: true);
        }

        final String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}${path.extension(image.path)}';
        final String savedPath = path.join(profilePicsDir.path, fileName);
        final File savedFile = await File(image.path).copy(savedPath);
        
        final oldPath = AppState.instance.profilePicturePath;
        if (oldPath != null && File(oldPath).existsSync()) {
          try {
            await File(oldPath).delete();
          } catch (e) {
            // Ignore deletion errors
          }
        }

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

  // ---------- Helper Widgets ----------
  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _settingsList(List<Widget> items) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.black, width: 2),
        ),
        child: Column(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              items[i],
              if (i < items.length - 1)
                const Divider(height: 1, color: Colors.black12),
            ],
          ],
        ),
      );

  Widget _settingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.black),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

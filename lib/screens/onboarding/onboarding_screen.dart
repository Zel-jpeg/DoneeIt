import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'id_card_screen.dart';
import 'course_folders_screen.dart';
import 'todo_list_screen.dart';
import '../profile/edit_id_screen.dart';
import '../../theme/app_theme.dart';

/// Onboarding flow screen with page view
/// Shows app features and navigates to ID card setup on completion
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Onboarding pages showcasing app features
  final List<Widget> _pages = const [
    IDCardScreen(),
    CourseFoldersScreen(),
    TodoListScreen(),
  ];

  /// Marks onboarding as complete and navigates to ID card setup
  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const EditIDScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            children: _pages,
          ),

          Positioned(
            left: 24,
            right: 24,
            bottom: 40,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage < _pages.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  _completeOnboarding(); // 👈 mark onboarding as completed
                }
              },
              child: Text(_currentPage < _pages.length - 1 ? 'Next' : "Let's get started!"),
            ),
          ),

          if (_currentPage < _pages.length - 1)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? AppTheme.black
                          : AppTheme.grey,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

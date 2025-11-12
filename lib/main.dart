import 'package:doneeit/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'theme/app_theme.dart';
import 'utils/app_state.dart';

/// Main entry point of the app
/// Initializes app state and checks if user has seen onboarding
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load saved app state (ID card info, preferences)
  await AppState.instance.load();

  // Check if user has completed onboarding
  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

  runApp(DoneeitApp(hasSeenOnboarding: hasSeenOnboarding));
}

/// Root widget of the application
/// Shows splash screen, then either onboarding or home screen
class DoneeitApp extends StatelessWidget {
  final bool hasSeenOnboarding;
  const DoneeitApp({super.key, required this.hasSeenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doneeit',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      // Show splash screen first, then navigate to appropriate screen
      home: SplashScreen(
        child: hasSeenOnboarding
            ? const HomeScreen()
            : const OnboardingScreen(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:olzhasmobileproject/videoCategories/tutorials.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginScreen.dart';
import 'registration.dart';
import 'ProfileScreen.dart';
import 'home.dart';
import 'LearnScreen.dart';
import 'VocabScreen.dart';
import 'LearnScreen1.dart';
import 'CategorySelectRead.dart';
import 'ForgotPassword.dart';
import 'GrammarGuide/GrammarGuide.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('onboarding_seen') ?? false;

  runApp(MyApp(hasSeenOnboarding: hasSeenOnboarding));
}

class MyApp extends StatelessWidget {
  final bool hasSeenOnboarding;

  const MyApp({super.key, required this.hasSeenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Language Learning App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
        ),
      ),

      initialRoute: hasSeenOnboarding ? '/login' : '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/vocab': (context) => const VocabScreen(),
        '/tutorials': (context) => const TutorialsScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
      },

      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final String token = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => HomeScreen(token: token),
          );
        }

        if (settings.name == '/profile') {
          final String token = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => ProfileScreen(token: token),
          );
        }

        if (settings.name == '/learn') {
          final String token = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => LearnScreen(token: token),
          );
        }

        if (settings.name == '/learn1') {
          final String token = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => LearnScreen1(token: token),
          );
        }

        if (settings.name == '/grammar') {
          final String token = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => GrammarGuideScreen(token: token),
          );
        }

        if (settings.name == '/category') {
          final String token = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => CategorySelectReadScreen(token: token),
          );
        }

        return null;
      },
    );
  }
}

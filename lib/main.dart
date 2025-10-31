import 'package:flutter/material.dart';
import 'package:olzhasmobileproject/videoCategories/tutorials.dart';
import 'LoginScreen.dart';
import 'registration.dart';
import 'ProfileScreen.dart';
import 'home.dart';
import 'LearnScreen.dart';
import 'VocabScreen.dart';
import 'LearnScreen1.dart';
import 'CategorySelectRead.dart';
import 'ForgotPassword.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Language Learning App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      
      initialRoute: '/login',
      routes: {
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

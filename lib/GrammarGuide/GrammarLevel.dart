import 'package:flutter/material.dart';

class GrammarLevelScreen extends StatelessWidget {
  final String? token;
  final String level;

  const GrammarLevelScreen({super.key, required this.level, this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Grammar – $level',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Content coming soon',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            'You selected a grammar level. This page can list topics, lessons, or exercises for the chosen level.',
          ),
        ],
      ),
    );
  }
}


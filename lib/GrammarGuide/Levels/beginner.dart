import 'package:flutter/material.dart';

class BeginnerLevelScreen extends StatelessWidget {
  const BeginnerLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beginner'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Beginner level – content coming soon'),
      ),
    );
  }
}

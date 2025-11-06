import 'package:flutter/material.dart';

class AdvancedLevelScreen extends StatelessWidget {
  const AdvancedLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Advanced level – content coming soon'),
      ),
    );
  }
}

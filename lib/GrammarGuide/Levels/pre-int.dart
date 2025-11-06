import 'package:flutter/material.dart';

class PreIntermediateLevelScreen extends StatelessWidget {
  const PreIntermediateLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pre-Intermediate'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Pre-Intermediate level – content coming soon'),
      ),
    );
  }
}

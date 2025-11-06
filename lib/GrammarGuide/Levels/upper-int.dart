import 'package:flutter/material.dart';

class UpperIntermediateLevelScreen extends StatelessWidget {
  const UpperIntermediateLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upper-Intermediate'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Upper-Intermediate level – content coming soon'),
      ),
    );
  }
}

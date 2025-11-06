import 'package:flutter/material.dart';

class IntermediateLevelScreen extends StatelessWidget {
  const IntermediateLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intermediate'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Intermediate level – content coming soon'),
      ),
    );
  }
}


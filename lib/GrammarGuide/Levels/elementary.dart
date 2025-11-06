import 'package:flutter/material.dart';

class ElementaryLevelScreen extends StatelessWidget {
  const ElementaryLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elementary'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Elementary level – content coming soon'),
      ),
    );
  }
}

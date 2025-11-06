import 'package:flutter/material.dart';
import 'package:olzhasmobileproject/GrammarGuide/Rules_advanced/conditional_first.dart';
import 'package:olzhasmobileproject/GrammarGuide/Rules_advanced/conditional_second.dart';
import 'package:olzhasmobileproject/GrammarGuide/Rules_advanced/conditional_third.dart';
import 'package:olzhasmobileproject/GrammarGuide/Rules_advanced/conditional_mixed.dart';

class AdvancedLevelScreen extends StatelessWidget {
  const AdvancedLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> topics = [
      {
        'title': 'First Conditional',
        'description': 'Real future condition; modals/imperatives; time words without will.',
        'screen': const FirstConditionalScreen(),
        'icon': Icons.filter_1,
      },
      {
        'title': 'Second Conditional',
        'description': 'Unreal present; were for all persons; could/might variations.',
        'screen': const SecondConditionalScreen(),
        'icon': Icons.filter_2,
      },
      {
        'title': 'Third Conditional',
        'description': 'Unreal past; modal variations; inversion with had.',
        'screen': const ThirdConditionalScreen(),
        'icon': Icons.filter_3,
      },
      {
        'title': 'Mixed Conditionals (Bonus)',
        'description': 'Cross-time situations: past→present and present→past results.',
        'screen': const MixedConditionalsScreen(),
        'icon': Icons.shuffle,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text(
          'Advanced Grammar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => topic['screen'] as Widget,
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 14),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blueAccent.withOpacity(0.15),
                  child: Icon(
                    topic['icon'],
                    color: Colors.blueAccent,
                    size: 26,
                  ),
                ),
                title: Text(
                  topic['title'],
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    topic['description'],
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


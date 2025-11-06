import 'package:flutter/material.dart';
import 'package:olzhasmobileproject/GrammarGuide/Rules_beginner/beginner_parts.dart';
import 'package:olzhasmobileproject/GrammarGuide/Rules_beginner/beginner_sentence.dart';
import 'package:olzhasmobileproject/GrammarGuide/Rules_beginner/beginner_tenses.dart';

class BeginnerLevelScreen extends StatelessWidget {
  const BeginnerLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> topics = [
      {
        'title': 'Parts of Speech',
        'description':
            'Learn about nouns, verbs, adjectives, and other essential parts of speech.',
        'screen': const BeginnerPartsScreen(),
        'icon': Icons.language_rounded,
      },
      {
        'title': 'Sentence Structure and Rules',
        'description':
            'Understand how to form sentences correctly and avoid common mistakes.',
        'screen': const BeginnerSentenceScreen(),
        'icon': Icons.article_rounded,
      },
      {
        'title': 'Verb Tenses',
        'description':
            'Learn when to use Present Simple, Continuous, Past Simple, and Present Perfect.',
        'screen': const BeginnerTensesScreen(),
        'icon': Icons.access_time_rounded,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text(
          'Beginner Grammar',
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

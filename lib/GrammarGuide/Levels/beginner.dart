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
    'description': 'Learn about nouns, verbs, adjectives, and other essential parts of speech.',
    'screen': const BeginnerPartsScreen(),
  },
  {
    'title': 'Sentence Structure and Rules',
    'description': 'Understand how to form sentences correctly and avoid common mistakes.',
    'screen': const BeginnerSentenceScreen(),
  },
  {
    'title': 'Verb Tenses',
    'description': 'Learn when to use Present Simple, Continuous, Past Simple, and Present Perfect.',
    'screen': const BeginnerTensesScreen(),
  },
];


    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Beginner Grammar'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                topic['title']!,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(topic['description']!),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => topic['screen'] as Widget),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

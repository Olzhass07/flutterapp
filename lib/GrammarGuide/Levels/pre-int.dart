import 'package:flutter/material.dart';
import 'package:olzhasmobileproject/GrammarGuide/Rules_preint/negatives.dart';
import 'package:olzhasmobileproject/GrammarGuide/Rules_preint/quantifiers.dart';
import 'package:olzhasmobileproject/GrammarGuide/Rules_preint/comparatives_superlatives.dart';

class PreIntermediateLevelScreen extends StatelessWidget {
  const PreIntermediateLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> topics = [
      {
        'title': 'Negatives',
        'description':
            'Form negatives with do/does/did + not, be + not, and modal + not.',
        'screen': const NegativesScreen(),
        'icon': Icons.remove_circle_outline,
      },
      {
        'title': 'Quantifiers',
        'description':
            'Use some/any, much/many, a lot of, few/little with count/uncount nouns.',
        'screen': const QuantifiersScreen(),
        'icon': Icons.format_list_numbered,
      },
      {
        'title': 'Comparatives & Superlatives',
        'description':
            'Use -er/more and -est/most; learn irregular forms and spelling changes.',
        'screen': const ComparativesSuperlativesPreIntScreen(),
        'icon': Icons.trending_up,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text(
          'Pre-Intermediate Grammar',
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


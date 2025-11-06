import 'package:flutter/material.dart';
import 'package:olzhasmobileproject/GrammarGuide/Rules_intermediate/comparatives_superlatives.dart';
import 'package:olzhasmobileproject/GrammarGuide/Rules_intermediate/can_could_must_have_to.dart';
import 'package:olzhasmobileproject/GrammarGuide/Rules_intermediate/future_will_goingto.dart';
import 'package:olzhasmobileproject/GrammarGuide/Rules_intermediate/adverbs_frequency.dart';

class IntermediateLevelScreen extends StatelessWidget {
  const IntermediateLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> topics = [
      {
        'title': 'Comparatives & Superlatives (Advanced use)',
        'description':
            'Use modifiers (much/far/a bit), as...as, less/least, and the...the... patterns.',
        'screen': const ComparativesSuperlativesIntScreen(),
        'icon': Icons.trending_up,
      },
      {
        'title': 'Can / Could / Must / Have to',
        'description':
            'Ability, permission and obligation: differences between must and have to; negatives (mustn\'t vs don\'t have to).',
        'screen': const ModalsAbilityObligationScreen(),
        'icon': Icons.rule_folder_outlined,
      },
      {
        'title': 'Future: will vs going to',
        'description':
            'Decisions, promises, offers (will) vs plans and evidence-based predictions (going to).',
        'screen': const FutureWillGoingToScreen(),
        'icon': Icons.forward_to_inbox_outlined,
      },
      {
        'title': 'Adverbs of Frequency',
        'description':
            'Position with main verbs, be, auxiliaries; common frequency expressions.',
        'screen': const AdverbsOfFrequencyScreen(),
        'icon': Icons.schedule,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text(
          'Intermediate Grammar',
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


import 'package:flutter/material.dart';
import 'package:olzhasmobileproject/GrammarGuide/Rules_upperint/reported_speech.dart';
import 'package:olzhasmobileproject/GrammarGuide/Rules_upperint/inversion_emphasis.dart';
import 'package:olzhasmobileproject/GrammarGuide/Rules_upperint/advanced_tenses.dart';

class UpperIntermediateLevelScreen extends StatelessWidget {
  const UpperIntermediateLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> topics = [
      {
        'title': 'Reported (Indirect) Speech',
        'description':
            'Backshift of tenses, pronoun/time changes, reporting questions/commands, and advanced reporting verbs.',
        'screen': const ReportedSpeechScreen(),
        'icon': Icons.record_voice_over_outlined,
      },
      {
        'title': 'Inversion for Emphasis',
        'description':
            'Negative adverbials, no sooner/hardly, only + phrase, not only..., so/such..., and conditional inversion.',
        'screen': const InversionForEmphasisScreen(),
        'icon': Icons.swap_vert,
      },
      {
        'title': 'Advanced Tenses',
        'description':
            'Perfect vs perfect continuous, past perfect uses, future perfect/continuous, and stative vs dynamic verbs.',
        'screen': const AdvancedTensesScreen(),
        'icon': Icons.access_time_filled_outlined,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text(
          'Upper-Intermediate Grammar',
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


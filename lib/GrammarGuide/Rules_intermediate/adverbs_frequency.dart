import 'package:flutter/material.dart';

class AdverbsOfFrequencyScreen extends StatelessWidget {
  const AdverbsOfFrequencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Adverbs of Frequency'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Position and Meaning',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _sectionTitle('Common adverbs'),
            _sectionText(
              'always (100%), usually, often, sometimes, occasionally, rarely/seldom, hardly ever, never (0%).',
            ),
            _exampleBlock([
              'I often read before bed.',
              'She hardly ever eats fast food.',
            ]),

            _sectionTitle('Position in the sentence'),
            _sectionText(
              'Before the main verb; after be. With auxiliaries, the adverb goes after the first auxiliary.',
            ),
            _exampleBlock([
              'I usually get up at 7.',
              'They are never late. (after be)',
              'You have often told me this. (after have)',
            ]),

            _sectionTitle('Frequency expressions'),
            _sectionText('every day/week, once/twice a week, three times a month. Usually go at the end or beginning.'),
            _exampleBlock([
              'I go to the gym three times a week.',
              'Every morning, he takes a cold shower.',
            ]),

            const SizedBox(height: 18),
            _tipBlock('Tip: Don\'t use double negatives with never (NOT: I don\'t never...).'),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 14),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
      );

  Widget _sectionText(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          text,
          style: const TextStyle(fontSize: 15.5, height: 1.6, color: Colors.black87),
        ),
      );

  Widget _exampleBlock(List<String> examples) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: examples
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    e,
                    style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
                  ),
                ),
              )
              .toList(),
        ),
      );

  Widget _tipBlock(String text) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.greenAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 15, color: Colors.black87, fontStyle: FontStyle.italic),
        ),
      );
}


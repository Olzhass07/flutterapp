import 'package:flutter/material.dart';

class QuantifiersScreen extends StatelessWidget {
  const QuantifiersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Quantifiers'),
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
              'Quantifiers: some, any, much, many, a lot of, few, little',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _sectionTitle('Countable vs Uncountable'),
            _sectionText(
              'Countable nouns (apples, cars) use many/few; Uncountable nouns (water, money) use much/little. "A lot of" works for both.',
            ),
            _exampleBlock([
              'many books, few mistakes',
              'much time, little sugar',
              'a lot of friends / a lot of rain',
            ]),

            _sectionTitle('some vs any'),
            _sectionText(
              'Use some in positive sentences and offers/requests. Use any in negatives and questions.',
            ),
            _exampleBlock([
              'We have some bread.',
              'Do you have any questions?',
              'There isn\'t any milk.',
              'Would you like some coffee?',
            ]),

            _sectionTitle('much/many vs a lot of/lots of'),
            _sectionText(
              'In positive sentences, a lot of/lots of are more common in speaking. Much/many are common in negatives and questions.',
            ),
            _exampleBlock([
              'She has a lot of energy. (pos)',
              'Do you have many classes today? (question)',
              'We don\'t have much time. (negative)',
            ]),

            _sectionTitle('few vs a few; little vs a little'),
            _sectionText(
              'few/little = almost none (negative idea); a few/a little = some (positive idea).',
            ),
            _exampleBlock([
              'Few people came. (almost none)',
              'A few people came. (some)',
              'There\'s little hope. (almost none)',
              'There\'s a little hope. (some)',
            ]),

            const SizedBox(height: 18),
            _tipBlock('Tip: In informal speech, "lots of" is very common and natural.'),
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


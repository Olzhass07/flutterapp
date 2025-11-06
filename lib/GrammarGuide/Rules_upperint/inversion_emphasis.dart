import 'package:flutter/material.dart';

class InversionForEmphasisScreen extends StatelessWidget {
  const InversionForEmphasisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Inversion for Emphasis'),
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
              'When do we invert subject and auxiliary?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _sectionTitle('Negative adverbials at the beginning'),
            _sectionText(
              'Place negative/limiting adverbials first for emphasis; invert auxiliary and subject. Common: hardly, scarcely, rarely, seldom, never, at no time.',
            ),
            _exampleBlock([
              'Rarely have I seen such dedication.',
              'Never have we faced a bigger challenge.',
              'Seldom does the team arrive late.',
            ]),

            _sectionTitle('No sooner / hardly / scarcely ... than/when'),
            _sectionText('Used to describe two quick past events. Inversion in the first clause.'),
            _exampleBlock([
              'No sooner had we started than it began to rain.',
              'Hardly had she sat down when the phone rang.',
            ]),

            _sectionTitle('Only + time/way/place/after/because/etc.'),
            _sectionText('When only + phrase comes first, invert in the main clause.'),
            _exampleBlock([
              'Only after the meeting did we understand the problem.',
              'Only by working together can we succeed.',
            ]),

            _sectionTitle('Not only ... but also'),
            _sectionText('If not only begins the sentence/clause, invert the first clause.'),
            _exampleBlock([
              'Not only did he apologize, but he also offered help.',
            ]),

            _sectionTitle('So / Such ... that (literary/formal inversion)'),
            _sectionText('In formal style, so/such at the beginning can trigger inversion.'),
            _exampleBlock([
              'So difficult was the exam that many failed.',
              'Such was her confidence that everyone believed her.',
            ]),

            _sectionTitle('Conditional inversion (if omitted)'),
            _sectionText('In formal style, we can invert with should / were / had to replace if-clauses.'),
            _exampleBlock([
              'Should you need help, call me. (= If you should need...)',
              'Were I you, I\'d take the offer. (= If I were you...)',
              'Had we known, we would have acted earlier. (= If we had known...)',
            ]),

            const SizedBox(height: 18),
            _tipBlock('Tip: Inversion needs an auxiliary. If there is none in the positive sentence, add do/does/did for present/past simple.'),
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
              .map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      e,
                      style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
                    ),
                  ))
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


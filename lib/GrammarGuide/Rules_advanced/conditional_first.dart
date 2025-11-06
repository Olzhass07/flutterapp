import 'package:flutter/material.dart';

class FirstConditionalScreen extends StatelessWidget {
  const FirstConditionalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('First Conditional (Real Future)'),
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
            const Text('Form & Use', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _sectionTitle('Structure'),
            _sectionText('If + Present Simple, will + base verb.'),
            _exampleBlock([
              'If it rains, we\'ll stay at home.',
              'If you study, you\'ll pass.',
            ]),

            _sectionTitle('Promises, warnings, offers'),
            _sectionText('Use will to show decisions about the future depending on a real condition.'),
            _exampleBlock([
              'If you need help, I\'ll come.',
              'If you touch that, you\'ll get burned.',
            ]),

            _sectionTitle('Variations of the main clause'),
            _sectionText('Modals and imperatives are also common: can/may/might/should.'),
            _exampleBlock([
              'If it\'s sunny, we can eat outside.',
              'If you see her, tell her to call me. (imperative)',
              'If you\'re tired, you should rest.',
            ]),

            _sectionTitle('Time and condition words (no will in the if-clause)'),
            _sectionText('when, as soon as, unless, provided (that), in case, before, after — use present in the clause.'),
            _exampleBlock([
              'I\'ll call you when I arrive. (not: will arrive)',
              'Take an umbrella in case it rains.',
              'Unless you hurry, you\'ll miss the bus. (= If you don\'t hurry...)',
            ]),

            const SizedBox(height: 18),
            _tipBlock('Tip: Commas are optional when the if-clause comes second. Place the comma when the if-clause comes first.'),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 14),
        child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
      );
  Widget _sectionText(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text, style: const TextStyle(fontSize: 15.5, height: 1.6, color: Colors.black87)),
      );
  Widget _exampleBlock(List<String> examples) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: examples
              .map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(e, style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5)),
                  ))
              .toList(),
        ),
      );
  Widget _tipBlock(String text) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.greenAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
        child: Text(text, style: const TextStyle(fontSize: 15, color: Colors.black87, fontStyle: FontStyle.italic)),
      );
}


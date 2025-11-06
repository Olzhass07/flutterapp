import 'package:flutter/material.dart';

class NegativesScreen extends StatelessWidget {
  const NegativesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Negatives'),
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
              'Forming Negatives in English',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _sectionTitle('1) Present Simple'),
            _sectionText(
              'Use do/does + not + base verb. Short forms: don\'t / doesn\'t.',
            ),
            _exampleBlock([
              'I don\'t like coffee.',
              'She doesn\'t play tennis.',
            ]),

            _sectionTitle('2) Past Simple'),
            _sectionText(
              'Use did + not + base verb. Short form: didn\'t.',
            ),
            _exampleBlock([
              'We didn\'t watch the film.',
              'He didn\'t understand the question.',
            ]),

            _sectionTitle('3) Be verbs (am/is/are/was/were)'),
            _sectionText(
              'Add not after the verb be. No do/does/did.',
            ),
            _exampleBlock([
              'I am not ready.',
              'They are not (aren\'t) at home.',
              'She was not (wasn\'t) busy yesterday.',
            ]),

            _sectionTitle('4) Modals (can, will, must, should, etc.)'),
            _sectionText(
              'Add not after the modal. Use short forms when possible.',
            ),
            _exampleBlock([
              'I can\'t swim well.',
              'We won\'t be late.',
              'You shouldn\'t eat so fast.',
            ]),

            _sectionTitle('5) Negative words'),
            _sectionText(
              'never, nobody/no one, nothing, nowhere. Do not use an extra not with these in standard English.',
            ),
            _exampleBlock([
              'I never drink soda. (NOT: I don\'t never...)',
              'No one knows the answer.',
              'There\'s nothing in the box.',
            ]),

            const SizedBox(height: 18),
            _tipBlock('Tip: In speaking, use short forms (don\'t, isn\'t, can\'t). They sound natural and are common.'),
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


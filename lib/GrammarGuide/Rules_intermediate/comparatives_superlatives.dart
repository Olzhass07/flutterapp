import 'package:flutter/material.dart';

class ComparativesSuperlativesIntScreen extends StatelessWidget {
  const ComparativesSuperlativesIntScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Comparatives & Superlatives (Int)'),
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
              'Beyond the basics',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _sectionTitle('Modifiers with comparatives'),
            _sectionText('Use much, far, a lot, a bit, slightly to make differences stronger or weaker.'),
            _exampleBlock([
              'This route is much faster than the other one.',
              'She\'s a bit taller than her sister.',
            ]),

            _sectionTitle('less/least'),
            _sectionText('Use less + adjective (comparative) and the least + adjective (superlative) with all adjectives.'),
            _exampleBlock([
              'This task is less urgent than that one.',
              'He\'s the least experienced person on the team.',
            ]),

            _sectionTitle('as ... as (equality)'),
            _sectionText('Use as + adjective + as to say things are equal. Use not as/so ... as for inequality.'),
            _exampleBlock([
              'This test is as difficult as the previous one.',
              'The room isn\'t as bright as before.',
            ]),

            _sectionTitle('the + comparative, the + comparative'),
            _sectionText('To show cause and effect with change: The more you practice, the better you get.'),
            _exampleBlock([
              'The earlier you go, the easier it is to find parking.',
              'The more I read, the more I understand.',
            ]),

            _sectionTitle('Comparatives with clauses'),
            _sectionText('You can follow than with a clause (subject + verb).'),
            _exampleBlock([
              'She arrived earlier than I expected.',
              'The meeting took longer than we planned.',
            ]),

            const SizedBox(height: 18),
            _tipBlock('Tip: Use the for superlatives (the most/least). Do not use than after superlatives.'),
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


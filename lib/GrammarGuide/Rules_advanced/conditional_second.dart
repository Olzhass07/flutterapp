import 'package:flutter/material.dart';

class SecondConditionalScreen extends StatelessWidget {
  const SecondConditionalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Second Conditional (Unreal Present)'),
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
            _sectionText('If + Past Simple, would + base verb.'),
            _exampleBlock([
              'If I had more time, I would travel more.',
              'If she lived closer, we would meet often.',
            ]),

            _sectionTitle('Meaning'),
            _sectionText('Unreal/imaginary present or future; less probable or hypothetical situations.'),
            _exampleBlock([
              'If I were rich, I would buy a house.',
              'If it snowed in June, we would be shocked.',
            ]),

            _sectionTitle('Were for all persons'),
            _sectionText('In formal/standard grammar, use were instead of was after if (If I were you...).'),
            _exampleBlock([
              'If I were you, I\'d accept the offer.',
            ]),

            _sectionTitle('Modal variations'),
            _sectionText('could/might instead of would to express ability/possibility.'),
            _exampleBlock([
              'If we left now, we could catch the train.',
              'If she tried harder, she might pass.',
            ]),

            const SizedBox(height: 18),
            _tipBlock('Tip: Use the past form after if to show distance from reality; it does not mean past time.'),
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


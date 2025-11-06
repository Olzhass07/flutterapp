import 'package:flutter/material.dart';

class ThereIsThereAreScreen extends StatelessWidget {
  const ThereIsThereAreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('There is / There are'),
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
              'There is / There are',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'We use “there is” and “there are” to say that something exists or is present somewhere. '
              'Используется, когда говорим, что что-то где-то находится или существует.',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 24),

            // SECTION 1
            _sectionTitle('🔹 Basic Rule'),
            _sectionText(
              'Use “there is” for singular nouns, and “there are” for plural nouns.',
            ),
            _exampleBlock([
              'There is a cat on the porch. 🐱',
              'There are many books on the table. 📚',
            ]),

            // SECTION 2
            _sectionTitle('⚖️ There is a number of / There are a number of'),
            _sectionText(
              'Both can appear correct. Use “is” if you focus on the group, and “are” if you focus on individual items. '
              'Можно использовать оба варианта, в зависимости от того, что важно: группа или элементы.',
            ),
            _exampleBlock([
              'There is a number of reasons to learn English.',
              'There are a number of reasons to learn English.',
              'Better: Many reasons to learn English. ✅',
            ]),

            // SECTION 3
            _sectionTitle('💬 There are a lot of'),
            _sectionText(
              'Use “there are” with plural nouns after “a lot of”. '
              'После “a lot of” — всегда “there are”, если существительное во множественном числе.',
            ),
            _exampleBlock([
              'There are a lot of people in the park. ✅',
              'There is a lot of people in the park. ❌',
            ]),

            // SECTION 4
            _sectionTitle('🏠 There is / There are with lists'),
            _sectionText(
              'If you list several items, use “there is” when the first noun is singular. '
              'Если первое слово в списке — в единственном числе, используем “there is”.',
            ),
            _exampleBlock([
              'There is a kitchen, a living room, and a bedroom in my apartment.',
              'There are a kitchen, a living room, and a bedroom. ❌ (sounds awkward)',
            ]),

            // SECTION 5
            _sectionTitle('🧠 Common Tip'),
            _sectionText(
              'When unsure — rewrite! You can often change “there is/are” to something simpler.\n'
              'Например: “There are many stars” → “Many stars are visible tonight.”',
            ),

            const SizedBox(height: 40),
            _tipBlock(
              '💡 Tip: When you start a sentence with “there is / there are”, the verb agrees with the FIRST noun that follows.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
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
        padding: const EdgeInsets.only(bottom: 18),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15.5,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
      );

  Widget _exampleBlock(List<String> examples) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 24),
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
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.5,
                    ),
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
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
}

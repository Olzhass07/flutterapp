import 'package:flutter/material.dart';

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Articles (a, an, the)'),
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
              'Articles in English Grammar',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Articles are short words that show whether a noun is specific or general. '
              'В английском языке артикли помогают понять, о чём мы говорим — о чём-то конкретном или общем.',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 24),

            // SECTION 1
            _sectionTitle('🔹 What are Articles?'),
            _sectionText(
              'Articles are placed before nouns to show if we mean something specific (definite) or unspecific (indefinite).',
            ),
            _exampleBlock([
              'After a long day, a cup of tea tastes good. (any cup)',
              'After the long day, the cup of tea tasted good. (specific cup)',
            ]),

            // SECTION 2
            _sectionTitle('📘 Types of Articles'),
            _sectionText(
              'There are three articles in English:\n'
              '1️⃣ Definite Article — “the”\n'
              '2️⃣ Indefinite Articles — “a” and “an”',
            ),
            _exampleBlock([
              'I drank a glass of orange juice.',
              'Would you like an orange?',
              'The weather is beautiful today.',
            ]),

            // SECTION 3
            _sectionTitle('🧩 When to use A or An'),
            _sectionText(
              'Use “a” before words starting with a consonant sound, and “an” before words starting with a vowel sound. '
              'Если слово начинается с согласного звука — “a”, если с гласного — “an”.',
            ),
            _exampleBlock([
              'a dog, a car, a banana',
              'an apple, an umbrella, an hour',
              'a university (sounds like "ju")',
            ]),

            // SECTION 4
            _sectionTitle('💬 Using Articles with Adjectives'),
            _sectionText(
              'When an adjective comes before a noun, the article depends on the adjective’s sound.',
            ),
            _exampleBlock([
              'a small gift',
              'an interesting story',
              'the colorful birds',
            ]),

            // SECTION 5
            _sectionTitle('🚫 Articles with Uncountable Nouns'),
            _sectionText(
              'Do NOT use “a / an” with uncountable nouns (неисчисляемые существительные): water, music, money, air, jewelry.',
            ),
            _exampleBlock([
              'some water, some information, some money',
              'a glass of water, a piece of jewelry',
            ]),

            // SECTION 6
            _sectionTitle('⚙️ Zero Article'),
            _sectionText(
              'Sometimes no article is needed — this is called a zero article. '
              'Используется, когда говорим об общем понятии или идее.',
            ),
            _exampleBlock([
              'We’re going out for dinner.',
              'I studied Chinese in school.',
              'Creativity helps people grow.',
            ]),

            // SECTION 7
            _sectionTitle('💡 Quick Tips'),
            _sectionText(
              '✔ Use “the” when both you and your listener know what you’re talking about.\n'
              '✔ Use “a/an” for something new or not specific.\n'
              '✔ Don’t use articles with languages, subjects, or meals.',
            ),

            const SizedBox(height: 40),
            _tipBlock(
              '💡 Tip: Listen to native speech — they often “drop” articles naturally. Try repeating short sentences aloud.',
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

import 'package:flutter/material.dart';

class QuestionFormsScreen extends StatelessWidget {
  const QuestionFormsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Question Forms'),
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
              'Question Forms (Interrogative Sentences)',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Interrogative sentences are questions. They help us get information, clarify things, or start conversations. '
              'Вопросительные предложения — это предложения, которые задают вопросы и требуют ответа.',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 24),

            // SECTION 1
            _sectionTitle('🔹 What is an Interrogative Sentence?'),
            _sectionText(
              'An interrogative sentence is a question. It usually begins with a question word '
              '(who, what, where, when, why, how) or a helping verb (do, does, is, are, can). '
              'It always ends with a question mark.',
            ),
            _exampleBlock([
              'What is your name?',
              'Do you like coffee?',
              'Can you swim?',
            ]),

            // SECTION 2
            _sectionTitle('💬 The Purpose of Questions'),
            _sectionText(
              'We use questions to get information, confirm something, or communicate politely. '
              'Вопросы помогают узнать, уточнить и общаться с другими.',
            ),

            // SECTION 3
            _sectionTitle('🧩 Structure of a Question'),
            _sectionText(
              'Most questions follow this pattern:\n'
              '👉 Question word + helping verb + subject + main verb.\n\n'
              'Example: What (question word) + is (helping verb) + your (subject) + name (main verb).',
            ),
            _exampleBlock([
              'What is your name?',
              'Where do you live?',
              'Why are you late?',
            ]),

            // SECTION 4
            _sectionTitle('❓ Yes / No Questions'),
            _sectionText(
              'These questions can be answered with “yes” or “no”. '
              'Обычно начинаются со вспомогательного глагола.',
            ),
            _exampleBlock([
              'Do you like music?',
              'Is she at home?',
              'Can they dance?',
            ]),

            // SECTION 5
            _sectionTitle('🧠 Wh- Questions'),
            _sectionText(
              '“Wh-” questions begin with words like who, what, where, when, why, or how. '
              'They require a detailed answer, not just “yes” or “no”.',
            ),
            _exampleBlock([
              'Where are you from?',
              'Why are you sad?',
              'How do you study English?',
            ]),

            // SECTION 6
            _sectionTitle('☕ Alternative Questions'),
            _sectionText(
              'These questions give choices using “or”.\n'
              'Такие вопросы содержат выбор между вариантами.',
            ),
            _exampleBlock([
              'Would you like tea or coffee?',
              'Are you going by car or bus?',
            ]),

            // SECTION 7
            _sectionTitle('🗨 Tag Questions'),
            _sectionText(
              'A tag question is a statement with a short question at the end. '
              'Используются, чтобы подтвердить или уточнить: “не так ли?”.',
            ),
            _exampleBlock([
              'It’s cold today, isn’t it?',
              'You like English, don’t you?',
            ]),

            // SECTION 8
            _sectionTitle('🎭 Rhetorical Questions'),
            _sectionText(
              'These are questions that don’t expect an answer. '
              'Они нужны для выражения эмоций или усиления речи.',
            ),
            _exampleBlock([
              'Who do you think you are?',
              'How could I forget?',
            ]),

            // SECTION 9
            _sectionTitle('⚙️ Rules for Making Questions'),
            _sectionText(
              '1️⃣ Subject-Verb Inversion: the verb comes before the subject.\n'
              '   Example: Are you ready?\n\n'
              '2️⃣ Use auxiliary verbs (do, did, will, can) to form questions.\n'
              '   Example: Did you see that?\n\n'
              '3️⃣ Always end with a question mark and raise your voice slightly at the end.',
            ),

            // SECTION 10
            _sectionTitle('🧭 Direct & Indirect Questions'),
            _sectionText(
              'Direct questions ask directly: “Where is the library?”\n'
              'Indirect questions are polite: “Could you tell me where the library is?”\n'
              'На русском: прямые — обычные вопросы, косвенные — вежливые формы.',
            ),

            // SECTION 11
            _sectionTitle('🔓 Open vs. Closed Questions'),
            _sectionText(
              'Open questions → require explanation.\nClosed questions → yes/no answers.',
            ),
            _exampleBlock([
              'Open: What do you think about this movie?',
              'Closed: Do you like this movie?',
            ]),

            // SECTION 12
            _sectionTitle('🚫 Common Mistakes'),
            _exampleBlock([
              '❌ You are going where? → ✅ Where are you going?',
              '❌ Do you can swim? → ✅ Can you swim?',
            ]),

            const SizedBox(height: 40),
            _tipBlock(
              '💡 Tip: Practice forming questions daily! Ask yourself: What? Where? Why? How? '
              'Repeat them aloud — это помогает “почувствовать” порядок слов в английском вопросе.',
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

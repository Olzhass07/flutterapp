import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'LearnScreen1.dart';

class LearnScreen extends StatefulWidget {
  final String token;

  const LearnScreen({super.key, required this.token});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen>
    with SingleTickerProviderStateMixin {
  int questionIndex = 0;
  String? selectedLevel;
  String? selectedLearningFormat;
  String? selectedStudyTime;
  bool? isDailyStudy;
  Set<String> selectedTopics = {};
  bool isLoading = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    
    _checkIfPreferencesExist();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> saveData() async {
    setState(() => isLoading = true);

    final response = await http.post(
      Uri.parse('http://localhost:3001/savePreferences'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: jsonEncode({
        'level': selectedLevel,
        'learningFormat': selectedLearningFormat,
        'studyTime': selectedStudyTime,
        'isDailyStudy': isDailyStudy,
        'topics': selectedTopics.toList(),
      }),
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LearnScreen1(token: widget.token),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save preferences')));
    }
  }

  Future<void> _checkIfPreferencesExist() async {
    try {
      final url = Uri.parse('http://localhost:3001/profile');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data['user'] as Map<String, dynamic>?;

        if (user != null) {
          final hasLevel =
              (user['level'] != null && (user['level'] as String).isNotEmpty);
          final hasTopics =
              (user['topics'] != null && (user['topics'] as List).isNotEmpty);

          if (hasLevel || hasTopics) {
            
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LearnScreen1(token: widget.token),
                ),
              );
            });
          }
        }
      }
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> questions = [
      _buildQuestion(
        icon: Icons.language,
        title: 'Your English level',
        subtitle: 'Choose your proficiency level',
        options: [
          {'label': 'Beginner', 'value': 'beginner'},
          {'label': 'Intermediate', 'value': 'intermediate'},
          {'label': 'Advanced', 'value': 'advanced'},
        ],
        selected: selectedLevel,
        onSelected: (v) => setState(() => selectedLevel = v),
      ),
      _buildQuestion(
        icon: Icons.video_library,
        title: 'Learning format',
        subtitle: 'Select how you prefer to study',
        options: [
          {'label': 'Video', 'value': 'video'},
          {'label': 'Books & Articles', 'value': 'books'},
          {'label': 'Flashcards', 'value': 'flashcards'},
        ],
        selected: selectedLearningFormat,
        onSelected: (v) => setState(() => selectedLearningFormat = v),
      ),
      _buildQuestion(
        icon: Icons.access_time,
        title: 'Study time',
        subtitle: 'How much time can you dedicate?',
        options: [
          {'label': '10–20 min', 'value': '10-20 minutes'},
          {'label': '30–60 min', 'value': '30-60 minutes'},
          {'label': '1–2 hours', 'value': '1-2 hours'},
        ],
        selected: selectedStudyTime,
        onSelected: (v) => setState(() => selectedStudyTime = v),
      ),
      _buildQuestion(
        icon: Icons.calendar_today,
        title: 'Daily study?',
        subtitle: 'Do you want to study every day?',
        options: [
          {'label': 'Yes', 'value': 'yes'},
          {'label': 'No', 'value': 'no'},
        ],
        selected: isDailyStudy == null ? null : (isDailyStudy! ? 'yes' : 'no'),
        onSelected: (v) => setState(() => isDailyStudy = v == 'yes'),
      ),
      _buildMultiSelect(
        icon: Icons.book,
        title: 'Topics',
        subtitle: 'Select what interests you most',
        options: [
          {'label': 'Travel', 'value': 'travel'},
          {'label': 'Business', 'value': 'business'},
          {'label': 'Science', 'value': 'science'},
          {'label': 'Culture', 'value': 'culture'},
          {'label': 'Health', 'value': 'health'},
          {'label': 'Tech', 'value': 'tech'},
          {'label': 'Economics', 'value': 'economics'},
          {'label': 'Music', 'value': 'music'},
          {'label': 'Movies', 'value': 'movies'},
          {'label': 'History', 'value': 'history'},
          {'label': 'Psychology', 'value': 'psychology'},
          {'label': 'Cooking', 'value': 'cooking'},
        ],
        selected: selectedTopics,
        onSelected: (val, selected) {
          setState(() {
            if (selected) {
              selectedTopics.add(val);
            } else {
              selectedTopics.remove(val);
            }
          });
        },
      ),
    ];

    bool isAnswered() {
      switch (questionIndex) {
        case 0:
          return selectedLevel != null;
        case 1:
          return selectedLearningFormat != null;
        case 2:
          return selectedStudyTime != null;
        case 3:
          return isDailyStudy != null;
        case 4:
          return selectedTopics.isNotEmpty;
        default:
          return false;
      }
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: questionIndex < questions.length
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: questions[questionIndex],
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 14,
                              ),
                            ),
                            onPressed: isAnswered()
                                ? () {
                                    _controller.reset();
                                    _controller.forward();
                                    setState(() => questionIndex++);
                                  }
                                : null,
                            child: Text(
                              questionIndex == questions.length - 1
                                  ? 'Finish'
                                  : 'Next',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 100,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Setup complete!',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.purpleAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 14,
                              ),
                            ),
                            onPressed: saveData,
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.purpleAccent,
                                  )
                                : const Text(
                                    'Continue',
                                    style: TextStyle(fontSize: 18),
                                  ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Map<String, String>> options,
    required String? selected,
    required Function(String) onSelected,
  }) {
    return Card(
      elevation: 8,
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(icon, color: Colors.blueAccent, size: 40),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: options
                  .map(
                    (opt) => ChoiceChip(
                      label: Text(opt['label']!),
                      labelStyle: TextStyle(
                        color: selected == opt['value']
                            ? Colors.white
                            : Colors.black,
                      ),
                      selected: selected == opt['value'],
                      selectedColor: Colors.blueAccent,
                      onSelected: (_) => onSelected(opt['value']!),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultiSelect({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Map<String, String>> options,
    required Set<String> selected,
    required Function(String, bool) onSelected,
  }) {
    return Card(
      elevation: 8,
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(icon, color: Colors.purpleAccent, size: 40),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: options
                  .map(
                    (opt) => FilterChip(
                      label: Text(opt['label']!),
                      selected: selected.contains(opt['value']),
                      selectedColor: Colors.purpleAccent,
                      labelStyle: TextStyle(
                        color: selected.contains(opt['value'])
                            ? Colors.white
                            : Colors.black,
                      ),
                      onSelected: (isSelected) =>
                          onSelected(opt['value']!, isSelected),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

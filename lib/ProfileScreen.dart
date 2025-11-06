import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'bottom_navbar.dart';
import 'db/vocab_db.dart';
import 'VocabScreen.dart';

class ProfileScreen extends StatefulWidget {
  final String token;
  final bool showBottomBar;
  const ProfileScreen({super.key, required this.token, this.showBottomBar = true});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool isSaving = false;
  List<Map<String, dynamic>> _vocab = [];
  bool _vocabLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
    _loadVocab();
  }

  Future<void> fetchProfile() async {
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
        setState(() {
          userData = data['user'] as Map<String, dynamic>?;
          isLoading = false;
        });
        // refresh vocab in case user id derivation depends on token
        _loadVocab();
      } else {
        setState(() => isLoading = false);
      }
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadVocab() async {
    try {
      final key = _deriveUserKey(widget.token);
      final items = await VocabDb.instance.fetchEntries(key);
      if (!mounted) return;
      setState(() {
        _vocab = items;
        _vocabLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _vocab = [];
        _vocabLoading = false;
      });
    }
  }

  String _deriveUserKey(String? token) {
    if (token == null || token.isEmpty) return 'guest';
    try {
      final parts = token.split('.');
      if (parts.length == 3) {
        String norm(String s) {
          final pad = (4 - s.length % 4) % 4;
          return s.replaceAll('-', '+').replaceAll('_', '/') + '=' * pad;
        }
        final payloadB64 = norm(parts[1]);
        final payload = jsonDecode(utf8.decode(base64.decode(payloadB64))) as Map<String, dynamic>;
        final candidates = [
          payload['sub'], payload['user_id'], payload['userId'], payload['id'], payload['uid'], payload['email'], payload['username'],
        ];
        for (final c in candidates) {
          if (c is String && c.isNotEmpty) return c;
          if (c is num) return c.toString();
        }
      }
    } catch (_) {}
    return token.length > 24 ? token.substring(0, 24) : token;
  }

  @override
  Widget build(BuildContext context) {
    final headerGradient = const LinearGradient(
      colors: [Color(0xFF4F46E5), Color(0xFF60A5FA)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Профиль',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        flexibleSpace: Container(decoration: BoxDecoration(gradient: headerGradient)),
        actions: [
          if (!isLoading && userData != null)
            IconButton(
              icon: const Icon(Icons.edit_rounded),
              tooltip: 'Редактировать',
              onPressed: _openEditPreferences,
            ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0E7FF), Color(0xFFF8FAFC)],
          ),
        ),
        child: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : userData == null
                  ? const Center(child: Text('Не удалось загрузить профиль'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: headerGradient,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.indigo.withOpacity(0.25),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 36,
                                  backgroundColor: Colors.white.withOpacity(0.2),
                                  child: const Icon(Icons.person_rounded, size: 40, color: Colors.white),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (userData!['name'] ?? '-') as String,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        (userData!['email'] ?? '-') as String,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  onPressed: _openEditPreferences,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF4F46E5),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  icon: const Icon(Icons.edit_rounded, size: 18),
                                  label: const Text('Изменить'),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Vocabulary snapshot
                          Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.book_rounded, color: Color(0xFF4F46E5)),
                                      const SizedBox(width: 8),
                                      const Text('Словарь', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                                      const Spacer(),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => VocabScreen(token: widget.token),
                                            ),
                                          ).then((_) => _loadVocab());
                                        },
                                        child: const Text('Открыть'),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  if (_vocabLoading)
                                    const Center(child: CircularProgressIndicator())
                                  else
                                    Text(
                                      'Слов сохранено: ${_vocab.length}',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                ],
                              ),
                            ),
                          ),

                          Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  _profileItem(Icons.school_rounded, 'Уровень', userData!['level']),
                                  const Divider(height: 20),
                                  _profileItem(Icons.video_library_rounded, 'Формат обучения', userData!['learningFormat']),
                                  const Divider(height: 20),
                                  _profileItem(Icons.access_time_rounded, 'Время занятия', userData!['studyTime']),
                                  const Divider(height: 20),
                                  _profileItem(Icons.calendar_today_rounded, 'Ежедневно', (userData!['isDailyStudy'] == true) ? 'Да' : 'Нет'),
                                  const Divider(height: 20),
                                  _profileItem(
                                    Icons.book_rounded,
                                    'Темы',
                                    (userData!['topics'] is List)
                                        ? (userData!['topics'] as List).join(', ')
                                        : (userData!['topics']?.toString() ?? '-'),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent.shade400,
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            icon: const Icon(Icons.logout_rounded),
                            label: const Text('Выйти', style: TextStyle(fontSize: 16)),
                            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
      bottomNavigationBar: widget.showBottomBar
          ? BottomNavBar(
              selectedIndex: 3,
              token: widget.token,
            )
          : null,
    );
  }

  Widget _profileItem(IconData icon, String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4F46E5)),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value?.toString() ?? '-',
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

 void _openEditPreferences() {
  if (userData == null || isSaving) return;

  final levels = const [
    'Beginner',
    'Elementary',
    'Pre-Intermediate',
    'Intermediate',
    'Upper-Intermediate',
    'Advanced'
  ];
  final formats = const ['Video', 'Reading', 'Mixed'];
  final times = const ['15 минут', '30 минут', '45 минут', '60 минут'];

  // ✅ Новый список тем
  final topicOptions = const [
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
  ];

  String level = (userData!['level'] ?? '')?.toString() ?? '';
  String learningFormat = (userData!['learningFormat'] ?? '')?.toString() ?? '';
  String studyTime = (userData!['studyTime'] ?? '')?.toString() ?? '';
  bool isDailyStudy = userData!['isDailyStudy'] == true;
  final List<String> topicsList = (userData!['topics'] is List)
      ? (userData!['topics'] as List).map((e) => e.toString()).toList()
      : (userData!['topics']?.toString().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList() ?? <String>[]);

  final selectedTopics = {...topicsList};
  final topicsController = TextEditingController(text: selectedTopics.join(', '));

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          Future<void> save() async {
            setModalState(() {});
            setState(() => isSaving = true);
            try {
              final url = Uri.parse('http://localhost:3001/savePreferences');
              final body = jsonEncode({
                'level': level,
                'learningFormat': learningFormat,
                'studyTime': studyTime,
                'isDailyStudy': isDailyStudy,
                'topics': selectedTopics.toList(),
              });

              final resp = await http.post(
                url,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer ${widget.token}',
                },
                body: body,
              );

              if (resp.statusCode == 200) {
                setState(() {
                  userData = {
                    ...?userData,
                    'level': level,
                    'learningFormat': learningFormat,
                    'studyTime': studyTime,
                    'isDailyStudy': isDailyStudy,
                    'topics': selectedTopics.toList(),
                  };
                  isSaving = false;
                });
                if (mounted) Navigator.pop(context);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Настройки обновлены')),
                  );
                }
              } else {
                setState(() => isSaving = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ошибка сохранения: ${resp.statusCode}')),
                );
              }
            } catch (e) {
              setState(() => isSaving = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ошибка сети: $e')),
              );
            }
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              top: 12,
              left: 16,
              right: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Text(
                  'Изменение настроек обучения',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: level.isNotEmpty && levels.contains(level) ? level : null,
                  items: levels.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Уровень',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => setModalState(() => level = v ?? ''),
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: learningFormat.isNotEmpty && formats.contains(learningFormat)
                      ? learningFormat
                      : null,
                  items: formats.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Формат обучения',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => setModalState(() => learningFormat = v ?? ''),
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: studyTime.isNotEmpty && times.contains(studyTime) ? studyTime : null,
                  items: times.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Время занятия',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => setModalState(() => studyTime = v ?? ''),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    const Text('Ежедневно', style: TextStyle(fontSize: 16)),
                    const Spacer(),
                    Switch(
                      value: isDailyStudy,
                      activeColor: const Color(0xFF4F46E5),
                      onChanged: (v) => setModalState(() => isDailyStudy = v),
                    ),
                  ],
                ),

                const SizedBox(height: 6),
                const Text('Темы (через запятую или выберите ниже)'),
                const SizedBox(height: 6),
                TextField(
                  controller: topicsController,
                  decoration: const InputDecoration(
                    hintText: 'Например: Travel, Business, Music',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text) {
                    final parts = text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList();
                    setModalState(() {
                      selectedTopics
                        ..clear()
                        ..addAll(parts);
                    });
                  },
                ),
                const SizedBox(height: 8),

                
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final topic in topicOptions)
                      FilterChip(
                        label: Text(topic['label']!),
                        selected: selectedTopics.contains(topic['value']),
                        onSelected: (sel) {
                          setModalState(() {
                            if (sel) {
                              selectedTopics.add(topic['value']!);
                            } else {
                              selectedTopics.remove(topic['value']!);
                            }
                            topicsController.text = selectedTopics.join(', ');
                          });
                        },
                      ),
                  ],
                ),

                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isSaving ? null : save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child:
                                CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.save_rounded),
                    label: Text(isSaving ? 'Сохранение...' : 'Сохранить'),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

}

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;
import 'db/vocab_db.dart';
import 'bottom_navbar.dart';

class VocabScreen extends StatefulWidget {
  final String? token;
  const VocabScreen({super.key, this.token});

  @override
  State<VocabScreen> createState() => _VocabScreenState();
}

class _VocabScreenState extends State<VocabScreen> {
  final _controller = TextEditingController();
  final _translator = GoogleTranslator();
  bool _saving = false;
  List<Map<String, dynamic>> _items = [];
  late String _userKey;

  @override
  void initState() {
    super.initState();
    _userKey = _deriveUserKey(widget.token);
    _load();
  }

  Future<void> _load() async {
    final list = await VocabDb.instance.fetchEntries(_userKey);
    if (!mounted) return;
    setState(() => _items = list);
  }

  Future<void> _addWord() async {
    final word = _controller.text.trim();
    if (word.isEmpty) return;
    setState(() => _saving = true);
    try {
      final ruF = _translator.translate(word, to: 'ru');
      final kkF = _translator.translate(word, to: 'kk');
      final results = await Future.wait([ruF, kkF]);
      final ru = results[0].text;
      final kk = results[1].text;
      await VocabDb.instance.insertEntry(
        userToken: _userKey,
        word: word,
        ru: ru,
        kk: kk,
      );
      _controller.clear();
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Слово добавлено')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка перевода: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _deriveUserKey(String? token) {
    // Prefer a stable identifier embedded in JWT or similar token
    if (token == null || token.isEmpty) return 'guest';
    try {
      final parts = token.split('.');
      if (parts.length == 3) {
        String norm(String s) {
          // base64Url normalize
          final pad = (4 - s.length % 4) % 4;
          return s.replaceAll('-', '+').replaceAll('_', '/') + '=' * pad;
        }
        final payloadB64 = norm(parts[1]);
        final payload = jsonDecode(utf8.decode(base64.decode(payloadB64))) as Map<String, dynamic>;
        final candidates = [
          payload['sub'],
          payload['user_id'],
          payload['userId'],
          payload['id'],
          payload['uid'],
          payload['email'],
          payload['username'],
        ];
        for (final c in candidates) {
          if (c is String && c.isNotEmpty) return c;
          if (c is num) return c.toString();
        }
      }
    } catch (_) {}
    // Fallback: trim token to a short stable key to avoid super long storage keys
    return token.length > 24 ? token.substring(0, 24) : token;
  }

  Future<void> _showDetails(String word) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _WordDetailsSheet(
        word: word,
        translator: _translator,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFFFFFFF)],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Введите слово на английском',
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _addWord(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      onPressed: _saving ? null : _addWord,
                      icon: _saving
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.add),
                      label: const Text('Добавить'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _items.isEmpty
                  ? const Center(child: Text('Пока нет слов'))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final it = _items[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            leading: CircleAvatar(
                              backgroundColor: Colors.indigo.shade100,
                              child: Text(
                                (it['word'] ?? ' ')[0].toUpperCase(),
                                style: const TextStyle(color: Colors.indigo),
                              ),
                            ),
                            title: Text(
                              it['word'] ?? '',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: -4,
                                children: [
                                  _pill('RU: ${it['ru'] ?? ''}')
                                      ,
                                  _pill('KZ: ${it['kk'] ?? ''}')
                                ],
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Tooltip(
                                  message: 'Пример и вариации',
                                  child: IconButton(
                                    icon: const Icon(Icons.lightbulb_outline, color: Colors.amber),
                                    onPressed: () => _showDetails((it['word'] ?? '').toString()),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                  onPressed: () async {
                                    final id = it['id'] as int?;
                                    if (id != null) {
                                      await VocabDb.instance.deleteEntry(id);
                                      await _load();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 2, token: widget.token ?? ''),
    );
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.indigo, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _WordDetailsSheet extends StatefulWidget {
  final String word;
  final GoogleTranslator translator;
  const _WordDetailsSheet({required this.word, required this.translator});

  @override
  State<_WordDetailsSheet> createState() => _WordDetailsSheetState();
}

class _WordDetailsSheetState extends State<_WordDetailsSheet> {
  bool _loading = true;
  String? _exampleEn;
  String? _exampleRu;
  String? _exampleKk;
  List<String> _synonyms = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final details = await _fetchWordDetails(widget.word);
      final example = details['example'] as String?;
      final syns = (details['synonyms'] as List<String>?) ?? [];

      String ex = example ?? "Example: I'm learning the word '${widget.word}'.";
      final ruF = widget.translator.translate(ex, to: 'ru');
      final kkF = widget.translator.translate(ex, to: 'kk');
      final tr = await Future.wait([ruF, kkF]);

      if (!mounted) return;
      setState(() {
        _exampleEn = ex;
        _exampleRu = tr[0].text;
        _exampleKk = tr[1].text;
        _synonyms = syns.take(12).toList();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _exampleEn = "Example: I'm learning the word '${widget.word}'.";
        _exampleRu = null;
        _exampleKk = null;
        _synonyms = [];
        _loading = false;
      });
    }
  }

  Future<Map<String, dynamic>> _fetchWordDetails(String word) async {
    final uri = Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/' + Uri.encodeComponent(word));
    final resp = await http.get(uri).timeout(const Duration(seconds: 8));
    if (resp.statusCode != 200) return {};
    final data = jsonDecode(resp.body);
    if (data is! List || data.isEmpty) return {};
    final entry = data[0] as Map<String, dynamic>;
    final meanings = (entry['meanings'] as List?) ?? [];
    String? example;
    final Set<String> syns = {};
    for (final m in meanings) {
      final defs = (m['definitions'] as List?) ?? [];
      for (final d in defs) {
        if (example == null && d is Map && d['example'] is String) {
          example = d['example'] as String;
        }
        final dsyn = (d is Map && d['synonyms'] is List) ? List<String>.from(d['synonyms']) : <String>[];
        syns.addAll(dsyn);
      }
      final msyn = (m is Map && m['synonyms'] is List) ? List<String>.from(m['synonyms']) : <String>[];
      syns.addAll(msyn);
    }
    return {
      'example': example,
      'synonyms': syns.toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: _loading
            ? const SizedBox(height: 220, child: Center(child: CircularProgressIndicator()))
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lightbulb, color: Colors.amber),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.word,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (_exampleEn != null) ...[
                    const Text('Пример использования', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    _exampleTile('EN', _exampleEn!),
                    if (_exampleRu != null) _exampleTile('RU', _exampleRu!),
                    if (_exampleKk != null) _exampleTile('KZ', _exampleKk!),
                  ],
                  const SizedBox(height: 14),
                  if (_synonyms.isNotEmpty) ...[
                    const Text('Вариации (синонимы)', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: -4,
                      children: _synonyms.map((s) => Chip(label: Text(s))).toList(),
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _exampleTile(String tag, String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(tag, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

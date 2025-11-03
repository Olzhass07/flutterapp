import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
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

  String get _userKey => widget.token ?? 'guest';

  @override
  void initState() {
    super.initState();
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Введите слово на английском',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addWord(),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _saving ? null : _addWord,
                  child: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Добавить'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _items.isEmpty
                ? const Center(child: Text('Пока нет слов'))
                : ListView.separated(
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final it = _items[index];
                      return ListTile(
                        title: Text(it['word'] ?? ''),
                        subtitle: Text('RU: ${it['ru'] ?? ''}\nKZ: ${it['kk'] ?? ''}'),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            final id = it['id'] as int?;
                            if (id != null) {
                              await VocabDb.instance.deleteEntry(id);
                              await _load();
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 2, token: widget.token ?? ''),
    );
  }
}

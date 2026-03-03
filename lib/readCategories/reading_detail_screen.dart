import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

import '../db/vocab_db.dart';
import '../models/reading_item.dart';
import '../services/reading_repository.dart';
import '../utils/user_key.dart';

class ReadingDetailScreen extends StatefulWidget {
  final String? token;
  final ReadingItem item;
  final ReadingRepository repository;

  const ReadingDetailScreen({
    super.key,
    required this.token,
    required this.item,
    required this.repository,
  });

  @override
  State<ReadingDetailScreen> createState() => _ReadingDetailScreenState();
}

class _ReadingDetailScreenState extends State<ReadingDetailScreen> {
  final GoogleTranslator _translator = GoogleTranslator();
  late final String _userKey;

  @override
  void initState() {
    super.initState();
    _userKey = deriveUserKeyFromToken(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(widget.item.title),
        centerTitle: true,
      ),
      body: FutureBuilder<String>(
        future: widget.repository.loadText(widget.item),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Failed to load this text. Check that the asset path exists and is listed in pubspec.yaml.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final text = (snapshot.data ?? '').trim();
          if (text.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'This material is empty. Add text to the file and reopen the reader.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
            children: [
              _HeaderCard(item: widget.item),
              const SizedBox(height: 18),
              const Text(
                'Tap any highlighted word to translate it and save it to your vocabulary.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 18),
              _InteractiveArticle(
                text: text,
                onWordTap: _showWordSheet,
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showWordSheet(String word) async {
    final cleaned = _normalizeWord(word);
    if (cleaned.isEmpty) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _WordActionSheet(
        word: cleaned,
        userKey: _userKey,
        translator: _translator,
      ),
    );
  }

  String _normalizeWord(String input) {
    return input
        .replaceAll(RegExp(r"^[^A-Za-z]+|[^A-Za-z]+$"), '')
        .toLowerCase();
  }
}

class _HeaderCard extends StatelessWidget {
  final ReadingItem item;

  const _HeaderCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1D4ED8), Color(0xFF60A5FA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D4ED8).withValues(alpha: 0.20),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _headerPill(item.category.toUpperCase()),
              _headerPill(item.level.toUpperCase()),
              _headerPill('${item.minutes} MIN'),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            item.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.summary,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            item.sourceName.isNotEmpty ? item.sourceName : item.author,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerPill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InteractiveArticle extends StatelessWidget {
  final String text;
  final ValueChanged<String> onWordTap;

  const _InteractiveArticle({
    required this.text,
    required this.onWordTap,
  });

  @override
  Widget build(BuildContext context) {
    final spans = _tokenize(text).map((token) {
      if (token.trim().isEmpty) {
        return TextSpan(text: token);
      }

      final isWord = RegExp(r"^[A-Za-z]+(?:['-][A-Za-z]+)*$").hasMatch(token);
      if (!isWord) {
        return TextSpan(text: token);
      }

      return TextSpan(
        text: token,
        style: const TextStyle(
          color: Color(0xFF1D4ED8),
          fontWeight: FontWeight.w600,
        ),
        recognizer: TapGestureRecognizer()..onTap = () => onWordTap(token),
      );
    }).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            height: 1.7,
          ),
          children: spans,
        ),
      ),
    );
  }

  List<String> _tokenize(String value) {
    return RegExp(r"[A-Za-z]+(?:['-][A-Za-z]+)*|\s+|[^\sA-Za-z\n]|\n")
        .allMatches(value)
        .map((match) => match.group(0) ?? '')
        .toList();
  }
}

class _WordActionSheet extends StatefulWidget {
  final String word;
  final String userKey;
  final GoogleTranslator translator;

  const _WordActionSheet({
    required this.word,
    required this.userKey,
    required this.translator,
  });

  @override
  State<_WordActionSheet> createState() => _WordActionSheetState();
}

class _WordActionSheetState extends State<_WordActionSheet> {
  bool _loading = true;
  bool _saving = false;
  String? _ru;
  String? _kk;

  @override
  void initState() {
    super.initState();
    _loadTranslations();
  }

  Future<void> _loadTranslations() async {
    try {
      final values = await Future.wait([
        widget.translator.translate(widget.word, to: 'ru'),
        widget.translator.translate(widget.word, to: 'kk'),
      ]);
      if (!mounted) return;
      setState(() {
        _ru = values[0].text;
        _kk = values[1].text;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _saveWord() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final messenger = ScaffoldMessenger.of(context);
      await VocabDb.instance.insertEntry(
        userToken: widget.userKey,
        word: widget.word,
        ru: _ru ?? '',
        kk: _kk ?? '',
      );
      if (!mounted) return;
      Navigator.pop(context);
      messenger.showSnackBar(
        SnackBar(content: Text('"${widget.word}" added to vocabulary')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save word: $e')),
      );
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.word,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              _translationTile('RU', _ru ?? 'Translation unavailable'),
              const SizedBox(height: 10),
              _translationTile('KZ', _kk ?? 'Translation unavailable'),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saving ? null : _saveWord,
                  icon: _saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add_rounded),
                  label: const Text('Add to vocabulary'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    backgroundColor: const Color(0xFF1D4ED8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _translationTile(String label, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFDBEAFE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF1D4ED8),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

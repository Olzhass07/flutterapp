import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'db/vocab_db.dart';

class FlashcardsBlock extends StatefulWidget {
  final String token;
  const FlashcardsBlock({super.key, required this.token});

  @override
  State<FlashcardsBlock> createState() => _FlashcardsBlockState();
}

class _FlashcardsBlockState extends State<FlashcardsBlock> {
  bool _loading = true;
  List<Map<String, dynamic>> _vocab = [];

  @override
  void initState() {
    super.initState();
    _loadVocab();
  }

  Future<void> _loadVocab() async {
    try {
      final userKey = _deriveUserKey(widget.token);
      final list = await VocabDb.instance.fetchEntries(userKey);
      if (!mounted) return;
      setState(() {
        _vocab = list;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _vocab = [];
        _loading = false;
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
        final payload = jsonDecode(utf8.decode(base64.decode(payloadB64)))
            as Map<String, dynamic>;
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
    return token.length > 24 ? token.substring(0, 24) : token;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vocabCount = _vocab
        .map((item) => (item['word'] ?? '').toString().trim())
        .where((word) => word.isNotEmpty)
        .toSet()
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Flash cards',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        _FlashCardItem(
          title: 'Flashcards',
          subtitle: 'From vocabulary',
          countLabel: _loading ? 'Loading...' : '$vocabCount words',
          colors: const [Color(0xFF5B7CFA), Color(0xFF3559E0)],
          onTap: () => _openVocabFlashcards(context),
        ),
      ],
    );
  }

  void _openVocabFlashcards(BuildContext context) {
    if (_loading) return;
    final words = _vocab
        .where((item) => (item['word'] ?? '').toString().trim().isNotEmpty)
        .toList();

    if (words.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('В Vocabulary пока нет слов для повторения')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VocabFlashcardsScreen(
          items: words,
          userToken: _deriveUserKey(widget.token),
        ),
      ),
    );
  }
}

class _FlashCardItem extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? countLabel;
  final List<Color>? colors;
  final VoidCallback? onTap;

  const _FlashCardItem({
    this.title,
    this.subtitle,
    this.countLabel,
    this.colors,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardTitle = title ?? 'Flashcards';
    final gradientColors =
        colors ?? const [Color(0xFF5B7CFA), Color(0xFF3559E0)];
    final cardCount = countLabel ?? '';
    final cardSubtitle = subtitle;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 130),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.style_rounded, color: Colors.white),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cardTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (cardSubtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    cardSubtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
            Text(
              cardCount,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VocabFlashcardsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final String userToken;

  const VocabFlashcardsScreen({
    super.key,
    required this.items,
    required this.userToken,
  });

  @override
  State<VocabFlashcardsScreen> createState() => _VocabFlashcardsScreenState();
}

class _VocabFlashcardsScreenState extends State<VocabFlashcardsScreen> {
  final Random _rng = Random();
  final List<String> _forcedQueue = [];
  late final List<Map<String, dynamic>> _entries;
  final Map<String, Map<String, dynamic>> _stats = {};
  Timer? _idleHintTimer;
  int _seenCount = 0;
  int _sessionKnow = 0;
  int _sessionAgain = 0;
  int _currentIndex = 0;
  bool _showTranslation = false;
  bool _showSwipeHint = false;
  bool _isSubmitting = false;
  double _dragDx = 0;

  @override
  void initState() {
    super.initState();
    _entries = _uniqueEntries(widget.items);
    _loadStats();
    _scheduleIdleHint();
  }

  @override
  void dispose() {
    _idleHintTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadStats() async {
    final words = _entries.map((e) => (e['word'] ?? '').toString());
    final stats = await VocabDb.instance.fetchFlashcardStats(widget.userToken, words);
    if (!mounted) return;
    setState(() {
      _stats
        ..clear()
        ..addAll(stats);
      _currentIndex = _pickNextIndex();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_entries.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Flashcards'), centerTitle: true),
        body: const Center(child: Text('Нет слов для повторения')),
      );
    }

    final item = _entries[_currentIndex];
    final word = (item['word'] ?? '').toString();
    final ru = (item['ru'] ?? '').toString();
    final kk = (item['kk'] ?? '').toString();
    final totalSession = _sessionKnow + _sessionAgain;
    final mastery = totalSession == 0 ? 0 : ((_sessionKnow / totalSession) * 100).round();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text('Flashcards'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            top: -40,
            right: -30,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF5B7CFA).withValues(alpha: 0.10),
              ),
            ),
          ),
          Positioned(
            left: -40,
            bottom: 30,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF22C55E).withValues(alpha: 0.08),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              children: [
                Row(
                  children: [
                    _statPill(
                      icon: Icons.layers_rounded,
                      label: '${_seenCount + 1} / ${_entries.length}',
                      color: const Color(0xFF3559E0),
                    ),
                    const SizedBox(width: 8),
                    _statPill(
                      icon: Icons.auto_graph_rounded,
                      label: 'Mastery $mastery%',
                      color: const Color(0xFF16A34A),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.translate(
                        offset: const Offset(0, 14),
                        child: _deckGhost(0.12),
                      ),
                      Transform.translate(
                        offset: const Offset(0, 7),
                        child: _deckGhost(0.20),
                      ),
                      GestureDetector(
                        onTap: () {
                          _registerInteraction();
                          setState(() => _showTranslation = !_showTranslation);
                        },
                        onHorizontalDragUpdate: (details) {
                          _registerInteraction();
                          if (_isSubmitting) return;
                          setState(() {
                            _dragDx = (_dragDx + details.delta.dx).clamp(-170, 170).toDouble();
                          });
                        },
                        onHorizontalDragEnd: (_) => _submitByDrag(),
                        child: Transform.rotate(
                          angle: (_dragDx / 900).clamp(-0.20, 0.20).toDouble(),
                          child: Transform.translate(
                            offset: Offset(_dragDx, 0),
                            child: Stack(
                              children: [
                                _mainCard(word: word, ru: ru, kk: kk),
                                Positioned.fill(
                                  child: IgnorePointer(
                                    child: AnimatedOpacity(
                                      duration: const Duration(milliseconds: 120),
                                      opacity: (_dragDx.abs() / 120).clamp(0, 0.22).toDouble(),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(28),
                                          gradient: LinearGradient(
                                            colors: _dragDx >= 0
                                                ? [
                                                    const Color(0xFF22C55E),
                                                    const Color(0x8022C55E),
                                                  ]
                                                : [
                                                    const Color(0xFFEF4444),
                                                    const Color(0x80EF4444),
                                                  ],
                                            begin: _dragDx >= 0
                                                ? Alignment.centerLeft
                                                : Alignment.centerRight,
                                            end: _dragDx >= 0
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 18,
                                  left: 18,
                                  child: Opacity(
                                    opacity: (-_dragDx / 120).clamp(0, 1).toDouble(),
                                    child: _decisionBadge(
                                      label: 'AGAIN',
                                      color: const Color(0xFFEF4444),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 18,
                                  right: 18,
                                  child: Opacity(
                                    opacity: (_dragDx / 120).clamp(0, 1).toDouble(),
                                    child: _decisionBadge(
                                      label: 'KNOW',
                                      color: const Color(0xFF22C55E),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 24,
                        child: IgnorePointer(
                          child: AnimatedSlide(
                            duration: const Duration(milliseconds: 260),
                            offset: _showSwipeHint ? Offset.zero : const Offset(0, 0.25),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 260),
                              opacity: _showSwipeHint ? 1 : 0,
                              child: _swipeHintCard(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _actionButton(
                        label: 'Again',
                        icon: Icons.close_rounded,
                        color: const Color(0xFFEF4444),
                        onTap: () => _animateAndHandleAnswer(knew: false),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _actionButton(
                        label: 'Know',
                        icon: Icons.check_rounded,
                        color: const Color(0xFF22C55E),
                        onTap: () => _animateAndHandleAnswer(knew: true),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Swipe left if you do not know, swipe right if you know',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAnswer({required bool knew}) async {
    final current = _entries[_currentIndex];
    final word = (current['word'] ?? '').toString().trim().toLowerCase();
    if (word.isEmpty) return;

    await VocabDb.instance.recordFlashcardResult(
      userToken: widget.userToken,
      word: word,
      knew: knew,
    );

    final existing = _stats[word] ?? <String, dynamic>{};
    final left = _asInt(existing['left_count']);
    final right = _asInt(existing['right_count']);
    final wrongStreak = _asInt(existing['wrong_streak']);
    final now = DateTime.now().millisecondsSinceEpoch;

    int nextReviewAt;
    int nextLeft = left;
    int nextRight = right;
    int nextStreak = wrongStreak;

    if (knew) {
      nextRight += 1;
      nextStreak = 0;
      nextReviewAt = now + Duration(minutes: (right + 1) * 60).inMilliseconds;
    } else {
      nextLeft += 1;
      nextStreak += 1;
      final delayMinutes = (10 - (nextStreak * 2)).clamp(2, 10).toInt();
      nextReviewAt = now + Duration(minutes: delayMinutes).inMilliseconds;
      final repeatCount = nextStreak.clamp(1, 3);
      for (int i = 0; i < repeatCount; i++) {
        _forcedQueue.add(word);
      }
    }

    _stats[word] = {
      'word': word,
      'left_count': nextLeft,
      'right_count': nextRight,
      'wrong_streak': nextStreak,
      'next_review_at': nextReviewAt,
      'last_seen': now,
    };

    if (!mounted) return;
    setState(() {
      if (knew) {
        _sessionKnow += 1;
      } else {
        _sessionAgain += 1;
      }
      _dragDx = 0;
      _showTranslation = false;
      _seenCount += 1;
      _currentIndex = _pickNextIndex(excludeWord: word);
    });
  }

  void _submitByDrag() {
    _registerInteraction();
    if (_isSubmitting) return;
    final dx = _dragDx;
    if (dx <= -95) {
      _animateAndHandleAnswer(knew: false);
      return;
    }
    if (dx >= 95) {
      _animateAndHandleAnswer(knew: true);
      return;
    }
    setState(() => _dragDx = 0);
  }

  Future<void> _animateAndHandleAnswer({required bool knew}) async {
    if (_isSubmitting || !mounted) return;
    _registerInteraction();
    setState(() {
      _isSubmitting = true;
      _dragDx = knew ? 240 : -240;
    });
    await Future.delayed(const Duration(milliseconds: 180));
    if (!mounted) return;
    await _handleAnswer(knew: knew);
    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
      _dragDx = 0;
    });
  }

  void _registerInteraction() {
    _scheduleIdleHint();
    if (_showSwipeHint && mounted) {
      setState(() => _showSwipeHint = false);
    }
  }

  void _scheduleIdleHint() {
    _idleHintTimer?.cancel();
    _idleHintTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted || _isSubmitting) return;
      setState(() => _showSwipeHint = true);
    });
  }

  int _pickNextIndex({String? excludeWord}) {
    if (_entries.length == 1) return 0;

    if (_forcedQueue.isNotEmpty) {
      final forced = _forcedQueue.removeAt(0);
      final idx = _entries.indexWhere(
        (e) => (e['word'] ?? '').toString().trim().toLowerCase() == forced,
      );
      if (idx >= 0 &&
          (excludeWord == null ||
              (forced != excludeWord) ||
              _entries.length == 1)) {
        return idx;
      }
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final candidates = <int>[];
    final weights = <double>[];

    for (int i = 0; i < _entries.length; i++) {
      final normalized = (_entries[i]['word'] ?? '')
          .toString()
          .trim()
          .toLowerCase();
      if (normalized.isEmpty) continue;
      if (excludeWord != null && normalized == excludeWord) continue;

      final s = _stats[normalized] ?? const <String, dynamic>{};
      final left = _asInt(s['left_count']);
      final right = _asInt(s['right_count']);
      final streak = _asInt(s['wrong_streak']);
      final nextReviewAt = _asInt(s['next_review_at']);
      final due = nextReviewAt == 0 || nextReviewAt <= now;

      final base = 1.0 + (left * 1.5) + (streak * 2.0) - (right * 0.2);
      final withDue = due ? base * 1.2 : base * 0.35;
      final safe = withDue < 0.2 ? 0.2 : withDue;

      candidates.add(i);
      weights.add(safe);
    }

    if (candidates.isEmpty) {
      return (_currentIndex + 1) % _entries.length;
    }
    return candidates[_weightedPick(weights)];
  }

  int _weightedPick(List<double> weights) {
    double total = 0;
    for (final w in weights) {
      total += w;
    }
    double ticket = _rng.nextDouble() * total;
    for (int i = 0; i < weights.length; i++) {
      ticket -= weights[i];
      if (ticket <= 0) return i;
    }
    return weights.length - 1;
  }

  int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }

  List<Map<String, dynamic>> _uniqueEntries(List<Map<String, dynamic>> input) {
    final seen = <String>{};
    final out = <Map<String, dynamic>>[];
    for (final row in input) {
      final word = (row['word'] ?? '').toString().trim();
      if (word.isEmpty) continue;
      final key = word.toLowerCase();
      if (seen.contains(key)) continue;
      seen.add(key);
      out.add(row);
    }
    return out;
  }

  Widget _mainCard({required String word, required String ru, required String kk}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 170),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _dragDx > 12
              ? const [Color(0xFF15803D), Color(0xFF4ADE80)]
              : _dragDx < -12
              ? const [Color(0xFFDC2626), Color(0xFFFB7185)]
              : const [Color(0xFF3559E0), Color(0xFF6C8BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: (_dragDx > 12
                    ? const Color(0xFF16A34A)
                    : _dragDx < -12
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF3559E0))
                .withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.auto_awesome_rounded, color: Colors.white70, size: 28),
          const SizedBox(height: 12),
          Text(
            word,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: _showTranslation
                ? Text(
                    'RU: $ru\nKZ: $kk',
                    key: const ValueKey('translation'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : const Text(
                    'Tap card to reveal translation',
                    key: ValueKey('hint'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _deckGhost(double opacity) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(28),
      ),
    );
  }

  Widget _decisionBadge({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color.withValues(alpha: 0.20),
        border: Border.all(color: color, width: 1.4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 12,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _swipeHintCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.swipe_rounded, color: Color(0xFF3559E0), size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Swipe right if you know this word, or left if you do not.',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        height: 52,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.45)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statPill({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

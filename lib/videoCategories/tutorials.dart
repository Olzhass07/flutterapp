import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class TutorialsScreen extends StatefulWidget {
  const TutorialsScreen({super.key});

  @override
  State<TutorialsScreen> createState() => TutorialsScreenState();
}

class TutorialsScreenState extends State<TutorialsScreen> {
  final List<Map<String, String>> _videos = [
    {'id': 'q-_ezD9Swz4', 'title': 'Learn To Code Like a GENIUS and Not Waste Time'},
    {'id': 'NtfbWkxJTHw', 'title': 'How to Learn Coding FAST And Make Cool Stuff'},
    {'id': 'fWjsdhR3z3c', 'title': 'Learn Python in Less than 10 Minutes for Beginners (Fast & Easy)'},
  ];

  late YoutubePlayerController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: _videos[_currentIndex]['id']!,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
        enableCaption: true,
        showVideoAnnotations: false,
      ),
    );
  }

  void _playByIndex(int index) {
    setState(() => _currentIndex = index);
    _controller.loadVideoById(videoId: _videos[index]['id']!);
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Tutorials',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2563EB), Color(0xFF60A5FA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                clipBehavior: Clip.antiAlias,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: YoutubePlayer(controller: _controller),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _videos[_currentIndex]['title']!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.fullscreen_rounded),
                    onPressed: () => _controller.enterFullScreen(),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1, height: 12),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _videos.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final vid = _videos[index];
                  final id = vid['id']!;
                  final thumb = 'https://img.youtube.com/vi/$id/0.jpg';
                  final selected = index == _currentIndex;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFFE0E7FF)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: selected
                          ? Border.all(color: const Color(0xFF2563EB), width: 1.2)
                          : null,
                    ),
                    child: ListTile(
                      onTap: () => _playByIndex(index),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          thumb,
                          width: 100,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 100,
                            height: 56,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 36,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        vid['title']!,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? const Color(0xFF1E3A8A)
                              : Colors.black87,
                        ),
                      ),
                      trailing: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: selected
                            ? const Icon(
                                Icons.play_circle_fill_rounded,
                                key: ValueKey('selected'),
                                color: Color(0xFF2563EB),
                                size: 28,
                              )
                            : const Icon(
                                Icons.play_arrow_rounded,
                                key: ValueKey('unselected'),
                                color: Colors.grey,
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

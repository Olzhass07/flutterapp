import 'package:flutter/material.dart';
import 'videoCategories/tutorials.dart';
import 'videoCategories/documentaries.dart';
import 'videoCategories/movies.dart';
import 'videoCategories/podcasts.dart';

class CategorySelectVideo extends StatelessWidget {
  const CategorySelectVideo({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'title': 'Tutorials', 'count': '3 videos'},
      {'title': 'Documentaries', 'count': '3 videos'},
      {'title': 'Movies', 'count': '5 videos'},
      {'title': 'Podcasts', 'count': '4 videos'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Video Categories',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FAFC), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 30),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            childAspectRatio: 0.92,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return _buildCategoryCard(
              context,
              title: cat['title'],
              count: cat['count'],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String title,
    required String count,
  }) {
    final colors = _gradientFor(title);
    final icon = _iconFor(title);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          final lower = title.toLowerCase();
          if (lower == 'tutorials') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TutorialsScreen()),
            );
          } else if (lower == 'documentaries') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DocumentariesScreen()),
            );
          } else if (lower == 'movies') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MoviesScreen()),
            );
          } else if (lower == 'podcasts') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PodcastsScreen()),
            );
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.first.withOpacity(0.25),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -10,
                bottom: -10,
                child: Icon(
                  icon,
                  size: 120,
                  color: Colors.white.withOpacity(0.12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                          width: 0.8,
                        ),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        icon,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.play_circle_fill_rounded,
                          color: Colors.white.withOpacity(0.9),
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          count,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white.withOpacity(0.95),
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconFor(String title) {
    switch (title.toLowerCase()) {
      case 'tutorials':
        return Icons.school_rounded;
      case 'documentaries':
        return Icons.movie_filter_rounded;
      case 'movies':
        return Icons.local_movies_rounded;
      case 'podcasts':
        return Icons.podcasts_rounded;
      default:
        return Icons.folder_rounded;
    }
  }

  List<Color> _gradientFor(String title) {
    switch (title.toLowerCase()) {
      case 'tutorials':
        return const [Color(0xFF4F46E5), Color(0xFF60A5FA)];
      case 'documentaries':
        return const [Color(0xFF2563EB), Color(0xFF34D399)];
      case 'movies':
        return const [Color(0xFFDB2777), Color(0xFFF59E0B)];
      case 'podcasts':
        return const [Color(0xFF9333EA), Color(0xFF6366F1)];
      default:
        return const [Color(0xFF64748B), Color(0xFF94A3B8)];
    }
  }
}

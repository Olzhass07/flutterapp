import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'CategorySelectRead.dart';
import 'CategorySelectVideo.dart';
import 'home.dart';
import 'bottom_navbar.dart'; 
import 'GrammarGuide.dart';

class LearnScreen1 extends StatelessWidget {
  final String token;
  const LearnScreen1({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> sections = [
      {
        'title': 'Watch Videos',
        'color': Colors.purpleAccent,
        'icon': LucideIcons.playCircle,
        'image': 'https://cdn-icons-png.flaticon.com/512/711/711284.png',
      },
      {
        'title': 'Read Articles',
        'color': Colors.amberAccent,
        'icon': LucideIcons.bookOpen,
        'image': 'https://cdn-icons-png.flaticon.com/512/2232/2232688.png',
      },
      {
        'title': 'Grammar Guide',
        'color': Colors.greenAccent,
        'icon': LucideIcons.type,
        'image': 'https://cdn-icons-png.flaticon.com/512/2331/2331716.png',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Learn',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(token: token),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: sections.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final section = sections[index];
            return GestureDetector(
              onTap: () {
                if (section['title'] == 'Read Articles') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategorySelectReadScreen(token: token),
                    ),
                  );
                } else if (section['title'] == 'Watch Videos') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategorySelectVideo(),
                    ),
                  );
                } else if (section['title'] == 'Grammar Guide') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GrammarGuideScreen(token: token),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('РћС‚РєСЂС‹С‚Рѕ: ${section['title']}')),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: section['color'].withOpacity(0.85),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Opacity(
                        opacity: 0.15,
                        child: Image.network(
                          section['image'],
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: Icon(
                        section['icon'],
                        size: 40,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          section['title'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar:
          BottomNavBar(selectedIndex: 1, token: token), 
    );
  }
}


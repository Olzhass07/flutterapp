import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'CategorySelectRead.dart';
import 'CategorySelectVideo.dart';
import 'home.dart';
import 'bottom_navbar.dart'; 
import 'GrammarGuide/GrammarGuide.dart';

class LearnScreen1 extends StatelessWidget {
  final String token;
  const LearnScreen1({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> sections = [
      {
        'title': 'Watch Videos',
        'subtitle': 'Interactive lessons',
        'color': const Color(0xFF8B5CF6), // modern purple
        'icon': LucideIcons.playCircle,
      },
      {
        'title': 'Read Articles',
        'subtitle': 'Improve reading',
        'color': const Color(0xFFF59E0B), // modern amber
        'icon': LucideIcons.bookOpen,
      },
      {
        'title': 'Grammar Guide',
        'subtitle': 'Rules & practice',
        'color': const Color(0xFF10B981), // modern emerald
        'icon': LucideIcons.checkSquare,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text(
          'Learning Path',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Choose your activity",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sections.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final section = sections[index];
                  final color = section['color'] as Color;

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
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              section['icon'],
                              size: 32,
                              color: color,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  section['title'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  section['subtitle'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.grey.shade400,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 1, token: token), 
    );
  }
}



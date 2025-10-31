import 'dart:async';
import 'package:flutter/material.dart';
import 'ProfileScreen.dart';
import 'LearnScreen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  final String token;
  const HomeScreen({super.key, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Map<String, String>> _books = [
    {
      'title': 'Книга 1',
      'image': 'https://picsum.photos/id/1011/400/200',
      'description': 'Описание книги 1',
    },
    {
      'title': 'Книга 2',
      'image': 'https://picsum.photos/id/1012/400/200',
      'description': 'Описание книги 2',
    },
    {
      'title': 'Книга 3',
      'image': 'https://picsum.photos/id/1013/400/200',
      'description': 'Описание книги 3',
    },
  ];

  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _books.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onBookTap(Map<String, String> book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(book['title'] ?? ''),
        content: Text('Открыть "${book['title']}" для чтения или просмотра?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Открыта книга: ${book['title']}')),
              );
            },
            child: const Text('Открыть'),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _books.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final book = _books[index];
              return GestureDetector(
                onTap: () => _onBookTap(book),
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          book['image'] ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.5),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        bottom: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book['title'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(blurRadius: 4, color: Colors.black),
                                ],
                              ),
                            ),
                            Text(
                              book['description'] ?? '',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                shadows: [
                                  Shadow(blurRadius: 4, color: Colors.black),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_books.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              width: _currentPage == index ? 16 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index ? Colors.indigo : Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> titles = ['HomePage', 'Learn', 'Vocabulary', 'Profile'];

    final List<Widget> pages = [
      SingleChildScrollView(
        child: Column(
          children: [
            _buildBanner(),
            const SizedBox(height: 24),
            const Text(
              'Добро пожаловать!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text('Выберите книгу или используйте нижнюю навигацию.'),
          ],
        ),
      ),
      LearnScreen(token: widget.token),
      const Center(child: Text('Vocabulary')),
      ProfileScreen(token: widget.token, showBottomBar: false),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectedIndex]),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: GNav(
          gap: 8,
          backgroundColor: Colors.white,
          color: Colors.grey[600],
          activeColor: Colors.white,
          tabBackgroundColor: Colors.indigo,
          padding: const EdgeInsets.all(12),
          selectedIndex: _selectedIndex,
          onTabChange: _onItemTapped,
          tabs: const [
            GButton(icon: Icons.home, text: 'Home'), 
            GButton(icon: Icons.school, text: 'Learn'),
            GButton(icon: Icons.book, text: 'Vocab'),
            GButton(icon: Icons.person, text: 'Profile'),
          ],
        ),
      ),
    );
  }
}

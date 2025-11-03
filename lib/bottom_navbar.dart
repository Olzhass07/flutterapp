import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../home.dart';
import '../LearnScreen1.dart';
import '../ProfileScreen.dart';
import '../VocabScreen.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final String token;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.token,
  });

  void _onItemTapped(BuildContext context, int index) {
  if (index == selectedIndex) return;

  Widget nextPage;
  switch (index) {
    case 0:
      nextPage = HomeScreen(token: token);
      break;
    case 1:
      nextPage = LearnScreen1(token: token);
      break;
    case 2:
      nextPage = VocabScreen(token: token);
      break;
    case 3:
      nextPage = ProfileScreen(token: token);
      break;
    default:
      return;
  }

  Navigator.of(context).pushAndRemoveUntil(
    PageRouteBuilder(
      pageBuilder: (_, __, ___) => nextPage,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ),
    (route) => false, 
  );
}


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: SafeArea(
        top: false,
        child: GNav(
          gap: 8,
          backgroundColor: Colors.white,
          color: Colors.grey[600],
          activeColor: Colors.white,
          tabBackgroundColor: Colors.indigo,
          padding: const EdgeInsets.all(12),
          selectedIndex: selectedIndex,
          onTabChange: (index) => _onItemTapped(context, index),
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

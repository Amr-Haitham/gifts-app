import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomeSkeletonView extends StatefulWidget {
  final Widget home;
  final Widget profile;
  final Widget friends;
  const HomeSkeletonView(
      {super.key,
      required this.home,
      required this.profile,
      required this.friends});

  @override
  State<HomeSkeletonView> createState() => _HomeSkeletonViewState();
}

class _HomeSkeletonViewState extends State<HomeSkeletonView> {
  int _selectedIndex = 0;
  late final List<Widget> _screens = [
    widget.home,
    widget.profile,
    widget.friends,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: GNav(
          gap: 8,
          padding: EdgeInsets.all(16),
          backgroundColor: Colors.blueGrey,
          tabBackgroundColor: Colors.white,
          activeColor: Colors.grey.shade900,
          onTabChange: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          tabs: const [
            GButton(icon: Icons.home, text: 'Home'),
            GButton(icon: Icons.search, text: 'Profile'),
            GButton(icon: Icons.person, text: 'Friends'),
          ]),
    );
  }
}

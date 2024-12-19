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
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
        child: GNav(
          gap: 8,
          padding: const EdgeInsets.all(16),
          // backgroundColor: , // Dark background for the navbar
          tabBackgroundColor:
              Colors.grey[800]!, // Slightly lighter for active tabs
          activeColor: Colors.white, // Active icon and text color
          color: Colors.grey[400], // Inactive icon and text color
          onTabChange: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.person,
              text: 'Profile',
            ),
            GButton(
              icon: Icons.group,
              text: 'Friends',
            ),
          ],
        ),
      ),
    );
  }
}

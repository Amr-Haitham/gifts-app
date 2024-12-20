import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../controller/notifications/notification_cubit_controller.dart';

class HomeSkeletonView extends StatefulWidget {
  final Widget home;
  final Widget profileDrawer;
  final Widget friends;
  const HomeSkeletonView(
      {super.key,
      required this.home,
      required this.profileDrawer,
      required this.friends});

  @override
  State<HomeSkeletonView> createState() => _HomeSkeletonViewState();
}

class _HomeSkeletonViewState extends State<HomeSkeletonView> {
  @override
  initState() {
    BlocProvider.of<NotificationCubit>(context)
        .startListening(userId: FirebaseAuth.instance.currentUser!.uid);

    super.initState();
  }

  int _selectedIndex = 0;
  late final List<Widget> _screens = [
    widget.home,
    // widget.profileDrawer,
    widget.friends,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: widget.profileDrawer,
      body: Center(
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
        child: GNav(
          gap: 8,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
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
              key: Key("homeButtonTestKey"),
              icon: Icons.home,
              text: 'Home',
            ),
            // GButton(
            //   icon: Icons.person,
            //   text: 'Profile',
            // ),
            GButton(
              key:Key("friendsButtonTestKey"), 
              icon: Icons.group,
              text: 'Friends',
            ),
          ],
        ),
      ),
    );
  }
}

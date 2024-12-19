import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifts_app/model/classes/custom_user.dart';

import '../constants/app_router.dart';
import '../controller/custom_users/get_custom_user_controller.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late CustomUser appUser;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetAppUserCubit>(context)
        .getAppUser(uid: FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                BlocBuilder<GetAppUserCubit, GetAppUserState>(
                  builder: (context, state) {
                    if (state is GetAppUserLoaded) {
                      return ProfileHeader(
                        appUser: state.appUser,
                      );
                    } else if (state is GetAppUserError) {
                      return const Text('Error');
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RedButton(
                        label: "My events",
                        onPressed: () {
                          Navigator.pushNamed(
                              context, Routes.myEventsScreenRoute);
                        }),
                    const SizedBox(height: 16),
                    RedButton(
                        label: "pledged by me",
                        onPressed: () {
                          Navigator.pushNamed(
                              context, Routes.pledgedByMeScreenRoute);
                        }),
                  ],
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: LogoutButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key, required this.appUser}) : super(key: key);
  final CustomUser appUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.transparent,
          //problems
          backgroundImage: NetworkImage("url"), // Replace with your image URL
        ),
        const SizedBox(height: 12),
        Text(
          appUser.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class RedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const RedButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 150,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: () {
          FirebaseAuth.instance.signOut().then((value) =>
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.authWrapper, (route) => false));
        },
        child: const Text(
          "Log out",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
  }
}

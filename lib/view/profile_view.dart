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
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetAppUserCubit>(context)
        .getAppUser(uid: FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        const SizedBox(height: 20),
        BlocBuilder<GetAppUserCubit, GetAppUserState>(
          builder: (context, state) {
            if (state is GetAppUserLoaded) {
              return ProfileHeader(
                appUser: state.appUser,
              );
            } else if (state is GetAppUserError) {
              return Center(
                child: const Text(
                  'Error',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return Center(
              child: const CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          },
        ),
        ListTile(
          trailing: Icon(Icons.arrow_right, color: Colors.white),
          title: const Text('My Events'),
          onTap: () {
            Navigator.pushNamed(context, Routes.myEventsScreenRoute);
            // Navigator.pop(context);
          },
        ),
        GestureDetector(
          onTap: () {
            // Navigator.pop(context);
          },
          child: ListTile(
              trailing: Icon(Icons.arrow_right, color: Colors.white),
              title: const Text('My pledges'),
              onTap: () {
                Navigator.pushNamed(context, Routes.pledgedByMeScreenRoute);
              }),
        )
      ]),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     elevation: 0,
    //     backgroundColor: Colors.black,
    //     iconTheme: const IconThemeData(color: Colors.white),
    //   ),
    //   body: Container(
    //     color: Colors.black,
    //     width: double.infinity,
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         Column(
    //           children: [
    //             const SizedBox(height: 20),
    //             BlocBuilder<GetAppUserCubit, GetAppUserState>(
    //               builder: (context, state) {
    //                 if (state is GetAppUserLoaded) {
    //                   return ProfileHeader(
    //                     appUser: state.appUser,
    //                   );
    //                 } else if (state is GetAppUserError) {
    //                   return const Text(
    //                     'Error',
    //                     style: TextStyle(color: Colors.white),
    //                   );
    //                 }
    //                 return const CircularProgressIndicator(
    //                   color: Colors.white,
    //                 );
    //               },
    //             ),
    //             const SizedBox(height: 40),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //               children: [
    //                 RedButton(
    //                     label: "My Events",
    //                     onPressed: () {
    //                       Navigator.pushNamed(
    //                           context, Routes.myEventsScreenRoute);
    //                     }),
    //                 RedButton(
    //                     label: "My pledges",
    //                     onPressed: () {
    //                       Navigator.pushNamed(
    //                           context, Routes.pledgedByMeScreenRoute);
    //                     }),
    //               ],
    //             ),
    //           ],
    //         ),
    //         // const Padding(
    //         //   padding: EdgeInsets.symmetric(vertical: 20.0),
    //         //   child: LogoutButton(),
    //         // ),
    //       ],
    //     ),
    //   ),
    // );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key, required this.appUser}) : super(key: key);
  final CustomUser appUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage(appUser.imageUrl!),
          ),
          const SizedBox(width: 12),
          Text(
            appUser.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
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
          backgroundColor: Colors.grey[800],
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

// class LogoutButton extends StatelessWidget {
//   const LogoutButton({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 150,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.grey[800],
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//         ),
//         onPressed: () {
//           FirebaseAuth.instance.signOut().then((value) =>
//               Navigator.pushNamedAndRemoveUntil(
//                   context, Routes.authWrapper, (route) => false));
//         },
//         child: const Text(
//           "Log out",
//           style: TextStyle(color: Colors.white, fontSize: 16),
//         ),
//       ),
//     );
//   }
// }

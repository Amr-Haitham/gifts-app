import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifts_app/model/classes/custom_user.dart';
import 'package:uuid/uuid.dart';

import '../controller/custom_users/get_custom_users_conroller.dart';
import '../controller/friends/add_remove_friend_conroller.dart';
import '../controller/friends/get_all_friends_controller.dart';
import '../model/classes/friend.dart';

class AllUsersScreen extends StatefulWidget {
  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize the Cubits
    BlocProvider.of<GetAllUsersCubit>(context).getAllUsers();
    BlocProvider.of<GetAllFriendsCubit>(context).getAllFriends();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FollowUnfollowCubit, FollowUnfollowState>(
      listener: (context, state) {
        if (state is FollowUnfollowSuccess) {
          BlocProvider.of<GetAllFriendsCubit>(context).getAllFriends();
        }
      },
      child: Scaffold(
        // backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          title: const Text("Friends", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Users List
              BlocBuilder<GetAllUsersCubit, GetAllUsersState>(
                builder: (context, userState) {
                  if (userState is GetAllUsersLoading) {
                    return const CircularProgressIndicator();
                  }
                  if (userState is GetAllUsersError) {
                    return const Text('Error fetching users',
                        style: TextStyle(color: Colors.white));
                  }
                  var users = (userState as GetAllUsersLoaded).users;

                  return BlocBuilder<GetAllFriendsCubit, GetAllFriendsState>(
                    builder: (context, friendState) {
                      if (friendState is GetAllFriendsLoading) {
                        return const CircularProgressIndicator();
                      }
                      if (friendState is GetAllFriendsError) {
                        return const Text('Error fetching friends',
                            style: TextStyle(color: Colors.white));
                      }
                      var friends =
                          (friendState as GetAllFriendsLoaded).friends;

                      // Remove current user from list
                      users.removeWhere((user) =>
                          user.id == FirebaseAuth.instance.currentUser!.uid);

                      return Expanded(
                        child: ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            var user = users[index];
                            print(friends);
                            bool isFriend = friends
                                .any((friend) => friend.friendId == user.id);

                            return UserCard(
                              user: user,
                              isFriend: isFriend,
                              onTap: (userId) {
                                if (isFriend) {
                                  BlocProvider.of<FollowUnfollowCubit>(context)
                                      .removeFriend(friendId: userId);
                                } else {
                                  BlocProvider.of<FollowUnfollowCubit>(context)
                                      .addFriend(
                                          friend: Friend(
                                              friendId: userId,
                                              userId: FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              id: Uuid().v1()));
                                }
                              },
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final CustomUser user;
  final bool isFriend;
  final Function(String) onTap;

  const UserCard({
    Key? key,
    required this.user,
    required this.isFriend,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(user.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Card(
          color: Colors.grey[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // User Image or Default Avatar
                CircleAvatar(
                  backgroundImage: AssetImage(
                      user.imageUrl ?? 'https://via.placeholder.com/150'),
                  radius: 30,
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(width: 16.0),
                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        user.phoneNumber,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                // Add/Remove Friend Button
                TextButton(
                  key: Key("AddRemoveFriendButtonTestKey"),
                  onPressed: () {},
                  child: Text(
                    isFriend ? "Remove Friend" : "Add Friend",
                    style:
                        TextStyle(color: isFriend ? Colors.grey : Colors.green),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

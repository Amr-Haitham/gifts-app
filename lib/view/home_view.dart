import 'dart:convert';

import 'package:draggable_home/draggable_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io' show File, Platform;
import 'package:gifts_app/constants/utils.dart';
import 'package:gifts_app/controller/custom_users/get_custom_user_controller.dart';
import 'package:gifts_app/controller/custom_users/update_fcm_token_for_app_user/update_fcm_token_for_app_user_cubit.dart';
import 'package:gifts_app/controller/events/get_home_screen_events.dart';
import 'package:gifts_app/model/classes/custom_user.dart';
import 'package:gifts_app/model/sink/local_db.dart';

import '../constants/app_router.dart';
import '../controller/notifications/notification_cubit_controller.dart';
import '../model/classes/event.dart';
import '../model/classes/notification.dart' as CustomNotifications;
import 'general_widgets_view/dialogs.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<CustomUser, Event> friendToEvent = {};
  @override
  void initState() {
    BlocProvider.of<GetHomeScreenEvents>(context).getHomeScreenEvents();
    BlocProvider.of<GetAppUserCubit>(context).getAppUser(
        uid: FirebaseAuth.instance.currentUser!.uid); // Fetch user data
    BlocProvider.of<UpdateFcmTokenForAppUserCubit>(context)
        .updateFcmToken(uid: FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationCubit, CustomNotifications.Notification?>(
      listener: (context, notification) async {
        if (notification != null) {
          var noti =
              await DatabaseHelper().getNotificationById(notification.id);
          if (noti == null) {
            showNotificationDialog(context, notification);
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: DraggableHome(
          headerExpandedHeight: .15,
          title: Text('Home', style: TextStyle(color: Colors.white)),
          headerWidget: AppBar(
            elevation: 0,
            backgroundColor: Colors.grey[900],
            title: BlocBuilder<GetAppUserCubit, GetAppUserState>(
              builder: (context, state) {
                if (state is GetAppUserLoading) {
                  return const CircularProgressIndicator();
                } else if (state is GetAppUserError) {
                  return const Text('Error');
                }
                var appUser = (state as GetAppUserLoaded).appUser;
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage(appUser.imageUrl!),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      appUser.name,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white70),
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) =>
                      Navigator.pushNamedAndRemoveUntil(
                          context, Routes.authWrapper, (route) => false));
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white70),
                onPressed: () {
                  Navigator.pushNamed(context, Routes.notificationsScreenRoute);
                },
              ),
            ],
          ),
          body: [
            Container(
              height: MediaQuery.of(context).size.height * .8,
              child: Center(
                child:
                    BlocConsumer<GetHomeScreenEvents, GetHomeScreenEventsState>(
                  listener: (context, state) {
                    if (state is GetHomeScreenEventsLoaded) {
                      setState(() {
                        friendToEvent = state.friendToEvent;
                      });
                    }
                  },
                  builder: (context, state) {
                    if (state is GetHomeScreenEventsLoading ||
                        state is GetHomeScreenEventsInitial) {
                      return const CircularProgressIndicator(
                          color: Colors.white);
                    }
                    if (state is GetHomeScreenEventsError) {
                      return const Text('Error',
                          style: TextStyle(color: Colors.white));
                    }
                    var loadedState = state as GetHomeScreenEventsLoaded;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        SearchBar(
                          onSearch: (searchValue) {
                            print(searchValue);
                            friendToEvent = loadedState.friendToEvent;
                            print(loadedState.friendToEvent.length);
                            friendToEvent = Map<CustomUser, Event>.fromEntries(
                              friendToEvent.entries
                                  .where((entry) => entry.key.name
                                      .toLowerCase()
                                      .contains(searchValue.toLowerCase()))
                                  .map((entry) => MapEntry(
                                      entry.key as CustomUser,
                                      entry.value as Event)),
                            );
                            if (searchValue.isEmpty) {
                              friendToEvent = loadedState.friendToEvent;
                            }
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: CardList(
                            cardsData: friendToEvent,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key, this.onSearch}) : super(key: key);
  final Function(String)? onSearch;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        onChanged: onSearch,
        decoration: InputDecoration(
          hintText: "Search by friend name",
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          filled: true,
          fillColor: Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class CardList extends StatefulWidget {
  final Map<CustomUser, Event> cardsData;

  const CardList({Key? key, required this.cardsData}) : super(key: key);

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  @override
  Widget build(BuildContext context) {
    var allData = widget.cardsData.entries.toList();
    allData.removeWhere(
        (element) => element.key.id == FirebaseAuth.instance.currentUser!.uid);
    if (allData.isEmpty) {
      return const Center(
        child: Text(
          "No Upcoming events to show",
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const Divider(
        thickness: 1,
        color: Colors.white24,
      ),
      itemCount: allData.length,
      itemBuilder: (context, index) {
        final cardData = allData.elementAt(index);
        return EventCard(
          onTap: () {
            Navigator.pushNamed(context, Routes.giftsListScreenRoute,
                arguments: cardData.value);
          },
          title: cardData.key.name,
          name: cardData.key.phoneNumber,
          date: cardData.value.date.toDate().toString().substring(0, 10),
          imageUrl: cardData.key.imageUrl,
          eventName: cardData.value.name,
        );
      },
    );
  }
}

class EventCard extends StatefulWidget {
  final String title;
  final String name;
  final String date;
  final String? imageUrl;
  final String eventName;
  final Function()? onTap;

  const EventCard({
    Key? key,
    required this.title,
    required this.name,
    required this.onTap,
    required this.eventName,
    required this.date,
    this.imageUrl,
  }) : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          color: Colors.grey[850],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                if (widget.imageUrl != null)
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.imageUrl!),
                    radius: 30,
                  )
                else
                  const CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 30,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.name,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Text(
                        widget.eventName,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      Text(
                        widget.date,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                // const Icon(Icons.card_giftcard,
                //     color: Colors.white70, size: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

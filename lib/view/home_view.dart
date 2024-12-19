import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io' show File, Platform;
import 'package:flutter/material.dart';
import 'package:gifts_app/constants/utils.dart';
import 'package:gifts_app/controller/custom_users/get_custom_user_controller.dart';
import 'package:gifts_app/controller/events/get_home_screen_events.dart';
import 'package:gifts_app/model/classes/custom_user.dart';

import '../constants/app_router.dart';
import '../controller/notifications/notification_cubit.dart';
import '../model/classes/event.dart';
import '../model/classes/notification.dart' as CustomNotifications;
import 'general_widgets_view/dialogs.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    BlocProvider.of<GetHomeScreenEvents>(context).getHomeScreenEvents();
    BlocProvider.of<GetAppUserCubit>(context).getAppUser(
        uid: FirebaseAuth.instance.currentUser!.uid); // Fetch user data
    BlocProvider.of<NotificationCubit>(context).startListening();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationCubit, CustomNotifications.Notification?>(
      listener: (context, notification) {
        if (notification != null) {
          showNotificationDialog(context, notification);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
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
                    radius: 50,
                    backgroundColor: Colors.transparent,
                    //problem
                    backgroundImage: AssetImage('assets/images/man.jpeg'),  
                  ),
                  Text(
                    appUser.name,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.grey),
              onPressed: () {
                Navigator.pushNamed(context, Routes.notificationsScreenRoute);
              },
            ),
          ],
        ),
        body: Center(
          child: BlocBuilder<GetHomeScreenEvents, GetHomeScreenEventsState>(
            builder: (context, state) {
              if (state is GetHomeScreenEventsLoading ||
                  state is GetHomeScreenEventsInitial) {
                return const CircularProgressIndicator();
              }
              if (state is GetHomeScreenEventsError) {
                return const Text('Error');
              }
              var loadedState = state as GetHomeScreenEventsLoaded;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  const SearchBar(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: CardList(
                      cardsData: loadedState.friendToEvent,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(width: 16),
            FloatingActionButton(
              onPressed: () {
                // Handle add event button press
                Navigator.pushNamed(context, Routes.allUsersScreenRoute);
              },
              child: const Icon(Icons.contacts),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search by name or email",
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          filled: true,
          fillColor: Colors.black87,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
        ),
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
          style: TextStyle(color: Colors.black),
        ),
      );
    }
    return ListView.separated(
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
          color: Colors.grey[800],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                if (widget.imageUrl != null)
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.imageUrl!),
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
                const Icon(Icons.card_giftcard, color: Colors.grey, size: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

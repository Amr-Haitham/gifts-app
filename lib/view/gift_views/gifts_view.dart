import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_router.dart';
import '../../controller/gifts/delete_gift_conroller.dart';
import '../../controller/gifts/get_gifts_in_events_conroller.dart';
import '../../controller/gifts/set_gift_controller.dart';
import '../../model/classes/event.dart';

class GiftsListScreen extends StatefulWidget {
  final Event event;
  final bool isMyList;

  const GiftsListScreen({Key? key, required this.event, required this.isMyList})
      : super(key: key);

  @override
  State<GiftsListScreen> createState() => _GiftsListScreenState();
}

class _GiftsListScreenState extends State<GiftsListScreen> {
  @override
  void initState() {
    BlocProvider.of<GetGiftsForEventCubit>(context)
        .getGiftsForEvent(eventId: widget.event.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteGiftForEventCubit, DeleteGiftForEventState>(
          listener: (context, state) {
            if (state is DeleteGiftForEventLoaded) {
              BlocProvider.of<GetGiftsForEventCubit>(context)
                  .getGiftsForEvent(eventId: widget.event.id);
            }
          },
        ),
        BlocListener<SetGiftForEventCubit, SetGiftForEventState>(
          listener: (context, state) {
            print("workingingigng");
            if (state is SetGiftForEventLoaded) {
              BlocProvider.of<GetGiftsForEventCubit>(context)
                  .getGiftsForEvent(eventId: widget.event.id);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
          title: Column(
            children: [
              Text(
                widget.event.name,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                widget.event.date.toDate().toString().substring(0, 10),
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: BlocBuilder<GetGiftsForEventCubit,
                            GetGiftsForEventState>(
                          builder: (context, state) {
                            if (state is GetGiftsForEventLoaded) {
                              return ListView.separated(
                                itemCount: state.gifts.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.setGiftsScreenRoute,
                                      arguments: {
                                        "gift": state.gifts[index],
                                        "eventId": widget.event.id,
                                        "isMyGift": FirebaseAuth
                                                .instance.currentUser!.uid ==
                                            widget.event.userId
                                      },
                                    );
                                  },
                                  child: ListItem(
                                    title: state.gifts[index].name,
                                    isMyList: widget.isMyList,
                                    onDelete: () {
                                      BlocProvider.of<DeleteGiftForEventCubit>(
                                              context)
                                          .deleteGiftForEvent(
                                              giftId: state.gifts[index].id);
                                    },
                                    onEdit: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.setGiftsScreenRoute,
                                        arguments: {
                                          "gift": state.gifts[index],
                                          "eventId": widget.event.id,
                                          "isMyGift": FirebaseAuth
                                                  .instance.currentUser!.uid ==
                                              widget.event.userId
                                        },
                                      );
                                    },
                                  ),
                                ),
                              );
                            } else if (state is GetGiftsForEventError) {
                              return const Center(
                                  child: Text("Error",
                                      style: TextStyle(color: Colors.white)));
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    !(widget.isMyList)
                        ? const SizedBox()
                        : AddButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                Routes.setGiftsScreenRoute,
                                arguments: {
                                  "eventId": widget.event.id,
                                  "isMyGift":
                                      FirebaseAuth.instance.currentUser!.uid ==
                                          widget.event.userId
                                },
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final bool isMyList;
  final Function()? onDelete;
  final Function()? onEdit;

  const ListItem({
    Key? key,
    required this.title,
    this.imageUrl,
    required this.isMyList,
    this.onDelete,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.grey.shade800,
      title: Row(
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const Spacer(),
          if (isMyList)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
          if (isMyList)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
        ],
      ),
      trailing: imageUrl != null
          ? CircleAvatar(
              backgroundImage: NetworkImage(imageUrl!),
            )
          : null,
    );
  }
}

class AddButton extends StatelessWidget {
  const AddButton({Key? key, required this.onPressed}) : super(key: key);
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: onPressed,
        child: const Text(
          "Add",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

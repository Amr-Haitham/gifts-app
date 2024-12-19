import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_router.dart';
import '../../controller/events/delete_event_controller.dart';
import '../../controller/events/get_events_for_custom_user_conroller.dart';
import '../../controller/events/set_event_controller.dart';

class MyEventsScreen extends StatefulWidget {
  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  @override
  void initState() {
    BlocProvider.of<GetUserEventsCubit>(context)
        .getUserEvents(uid: FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SetEventCubit, SetEventState>(
          listener: (context, state) {
            BlocProvider.of<GetUserEventsCubit>(context)
                .getUserEvents(uid: FirebaseAuth.instance.currentUser!.uid);
          },
        ),
        BlocListener<DeleteEventCubit, DeleteEventState>(
          listener: (context, state) {
            BlocProvider.of<GetUserEventsCubit>(context)
                .getUserEvents(uid: FirebaseAuth.instance.currentUser!.uid);
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
          title: const Text(
            "My events",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: BlocBuilder<GetUserEventsCubit, GetUserEventsState>(
                builder: (context, state) {
                  if (state is GetUserEventsError) {
                    return Text("error");
                  } else if (state is GetUserEventsLoaded) {
                    if (state.events.isEmpty) {
                      return const Center(child: Text("No events yet"));
                    }

                    return ListView.separated(
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 16),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      itemCount: state.events.length,
                      itemBuilder: (context, index) {
                        return ListButton(
                          label: state.events[index].name,
                          onDelete: () {
                            BlocProvider.of<DeleteEventCubit>(context)
                                .deleteEvent(eventId: state.events[index].id);
                          },
                          onEdit: () {
                            Navigator.pushNamed(
                                context, Routes.eventFormScreenRoute,
                                arguments: state.events[index]);
                          },
                          onPressed: () {
                            Navigator.pushNamed(
                                context, Routes.giftsListScreenRoute,
                                arguments: state.events[index]);
                          },
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: AddButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class ListButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final Function() onDelete;
  final Function() onEdit;

  const ListButton({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.grey,
              ),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  const AddButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, Routes.eventFormScreenRoute);
        },
        child: const Text(
          "Add",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

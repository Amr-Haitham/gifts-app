import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifts_app/controller/pledges/get_custom_user_pledges_controller.dart';

class PledgedByMeScreen extends StatefulWidget {
  @override
  State<PledgedByMeScreen> createState() => _PledgedByMeScreenState();
}

class _PledgedByMeScreenState extends State<PledgedByMeScreen> {
  @override
  void initState() {
    BlocProvider.of<UserPledgesCubit>(context)
        .getUserPledges(userId: FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pledged by me'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: BlocBuilder<UserPledgesCubit, UserPledgesState>(
        builder: (context, state) {
          if (state is UserPledgesLoading || state is UserPledgesInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is UserPledgesError) {
            return const Center(
              child: Text('Error'),
            );
          }

          final pledges = (state as UserPledgesSuccess).pledges;
          if (pledges.isEmpty) {
            return const Center(
              child: Text('No pledges'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: pledges.length,
            itemBuilder: (context, index) {
              final pledge = pledges[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                elevation: 0,
                color: const Color(0xFFFFF5F5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(pledge.gift.imageUrl ?? "url"),
                    radius: 25.0,
                  ),
                  title: Text(
                    pledge.giftOwner.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    pledge.gift.name,
                    style: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

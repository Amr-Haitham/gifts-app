import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifts_app/controller/notifications/notificatoin_local_db_controller.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    BlocProvider.of<GetLocalNotificationsCubit>(context)
        .getLocalNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: BlocBuilder<GetLocalNotificationsCubit, GetLocalNotificationsState>(
        builder: (context, state) {
          if (state is GetLocalNotificationsLoading ||
              state is GetLocalNotificationsInitial) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is GetLocalNotificationsError) {
            return Center(child: Text('Error'));
          }
          var notifications =
              (state as GetLocalNotificationsSuccess).notifications;
          if (state.notifications.isEmpty) {
            return Center(child: Text('No notifications'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: state.notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CircleAvatar(
                    //   backgroundImage: NetworkImage(notification.),
                    //   radius: 25.0,
                    // ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.white),
                              children: [
                                TextSpan(
                                  text: notification.title + ' ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: notification.body),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            notification.createdAt.toString().substring(0, 10),
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

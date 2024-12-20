import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/classes/notification.dart';
import '../../model/sink/notifications_sink.dart';

class GetLocalNotificationsCubit extends Cubit<GetLocalNotificationsState> {
  GetLocalNotificationsCubit() : super(GetLocalNotificationsInitial());

  Future<void> getLocalNotifications() async {
    emit(GetLocalNotificationsLoading());
    try {
      List<Notification> notifications = await NotificationsSink()
          .getNotifications(userId: FirebaseAuth.instance.currentUser!.uid);
      emit(GetLocalNotificationsSuccess(notifications: notifications));
    } catch (e) {
      print(e);
      emit(GetLocalNotificationsError());
    }
  }
}

class GetLocalNotificationsState {}

class GetLocalNotificationsInitial extends GetLocalNotificationsState {}

class GetLocalNotificationsError extends GetLocalNotificationsState {}

class GetLocalNotificationsSuccess extends GetLocalNotificationsState {
  List<Notification> notifications;

  GetLocalNotificationsSuccess({required this.notifications});
}

class GetLocalNotificationsLoading extends GetLocalNotificationsState {}

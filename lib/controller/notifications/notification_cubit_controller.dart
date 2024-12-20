import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gifts_app/model/sink/notifications_sink.dart';

import '../../model/sink/collection_names.dart';
import '../../model/classes/notification.dart';

class NotificationCubit extends Cubit<Notification?> {
  final NotificationsSink _notificationsSink = NotificationsSink();
  final FirebaseFirestore _firestore;
  StreamSubscription? _subscription;

  NotificationCubit()
      : _firestore = FirebaseFirestore.instance,
        super(null);

  void startListening({required String userId}) {
    _subscription = _firestore
        .collection(FirestoreCollectionNames.usersCollection)
        .doc(userId)
        .collection(FirestoreCollectionNames.notificationsCollection)
        .orderBy('createdAt', descending: true) // Get the latest notification
        // .limit(1)
        .snapshots()
        .listen((snapshot) async {
      for (var doc in snapshot.docs) {
        final notification = Notification.fromJson(doc.data());
        _notificationsSink.setNotificationInLocalDb(notification: notification);
      }
      if (snapshot.docs.isNotEmpty) {
        final notification = Notification.fromJson(snapshot.docs.first.data());
        emit(notification); // Emit the latest notification
      }
    });
  }

  void stopListening() {
    _subscription?.cancel();
  }

  @override
  Future<void> close() {
    stopListening();
    return super.close();
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/sink/collection_names.dart';
import '../../model/classes/notification.dart';



class NotificationCubit extends Cubit<Notification?> {
  final FirebaseFirestore _firestore;
  final String userId;
  StreamSubscription? _subscription;

  NotificationCubit(this.userId)
      : _firestore = FirebaseFirestore.instance,
        super(null);

  void startListening() {
    
    _subscription = _firestore
        .collection(FirestoreCollectionNames.usersCollection)
        .doc(userId)
        .collection(FirestoreCollectionNames.notificationsCollection)
        .orderBy('createdAt', descending: true) // Get the latest notification
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final notification = Notification.fromJson(
            snapshot.docs.first.data());
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




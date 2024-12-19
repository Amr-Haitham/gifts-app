import 'package:cloud_firestore/cloud_firestore.dart';

import 'collection_names.dart';
import '../classes/notification.dart';

class NotificationsSink {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  setNotification(
      {required Notification notification, required String userId}) async {
    await firestore
        .collection(FirestoreCollectionNames.usersCollection)
        .doc(userId)
        .collection(FirestoreCollectionNames.notificationsCollection)
        .add(notification.toJson());
  }
}

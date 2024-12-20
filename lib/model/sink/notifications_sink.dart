import 'package:cloud_firestore/cloud_firestore.dart';

import 'collection_names.dart';
import '../classes/notification.dart';
import 'local_db.dart';

class NotificationsSink {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final dbHelper = DatabaseHelper();

  setNotification(
      {required Notification notification, required String userId}) async {
    await firestore
        .collection(FirestoreCollectionNames.usersCollection)
        .doc(userId)
        .collection(FirestoreCollectionNames.notificationsCollection)
        .add(notification.toJson());
  }

  Future<bool> setNotificationInLocalDb(
      {required Notification notification}) async {
    if (await dbHelper.getNotificationById(notification.id) == null) {
      await dbHelper.createNotification(notification);
      return true;
    } else {
      return false;
    }
  }

  Future<List<Notification>> getNotifications({required String userId}) {
    return dbHelper.getAllNotifications();
  }
}

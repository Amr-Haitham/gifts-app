import 'package:cloud_firestore/cloud_firestore.dart';

import '../classes/custom_user.dart';
import 'collection_names.dart';

class CustomUserSink {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> setSingleCustomUser(CustomUser customUser) {
    return _firebaseFirestore
        .collection(FirestoreCollectionNames.usersCollection)
        .doc(customUser.id)
        .set(customUser.toJson());
  }

  Future<CustomUser> getSingleCustomUser(String uid) async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore
            .collection(FirestoreCollectionNames.usersCollection)
            .doc(uid)
            .get();

    return CustomUser.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  Future<List<CustomUser>> getCustomUsersFromIds(
      {required List<String> ids}) async {
    if (ids.isEmpty) {
      return [];
    }
    QuerySnapshot snapshots = await _firebaseFirestore
        .collection(FirestoreCollectionNames.usersCollection)
        .where("id", whereIn: ids)
        .get();
    List<CustomUser> users = [];

    for (var doc in snapshots.docs) {
      users.add(CustomUser.fromJson(doc.data() as Map<String, dynamic>));
    }
    return users;
  }

  Future<List<CustomUser>> getAllCustomUsers() async {
    QuerySnapshot snapshots = await _firebaseFirestore
        .collection(FirestoreCollectionNames.usersCollection)
        .get();
    List<CustomUser> users = [];

    for (var doc in snapshots.docs) {
      users.add(CustomUser.fromJson(doc.data() as Map<String, dynamic>));
    }
    return users;
  }

}

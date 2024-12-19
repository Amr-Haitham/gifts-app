import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../classes/friend.dart';
import 'collection_names.dart';

class FriendshipSink {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> removeFriend({required String id}) async {
    return _firestore
        .collection(FirestoreCollectionNames.friendsCollection)
        .doc(id)
        .delete();
  }

  Future<void> addFriend({required Friend friend}) async {
    return _firestore
        .collection(FirestoreCollectionNames.friendsCollection)
        .doc(friend.id)
        .set(friend.toJson());
  }

  Future<List<Friend>> getAllFriends() async {
    QuerySnapshot snapshot = await _firestore
        .collection(FirestoreCollectionNames.friendsCollection)
        .get();
    List<Friend> friends = [];
    for (var doc in snapshot.docs) {
      friends.add(Friend.fromJson(doc.data() as Map<String, dynamic>));
    }
    return friends;
  }
}

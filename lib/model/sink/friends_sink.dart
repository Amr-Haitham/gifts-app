import 'package:cloud_firestore/cloud_firestore.dart';
import '../classes/custom_user.dart';
import '../classes/friend.dart';
import 'collection_names.dart';
import 'custom_user_sink.dart';

class FriendsSink {
  final _firestore = FirebaseFirestore.instance;
  Future<void> addFriend({required Friend friend}) async {
    return _firestore
        .collection(FirestoreCollectionNames.friendsCollection)
        .doc()
        .set(friend.toJson());
  }

  Future<List<CustomUser>> getAllFriendsForCustomUser(
      {required String uid}) async {
    var snapshot = await _firestore
        .collection(FirestoreCollectionNames.friendsCollection)
        .where('userId', isEqualTo: uid)
        .get();
    List<Friend> friends = [];

    for (var doc in snapshot.docs) {
      friends.add(Friend.fromJson(doc.data()));
    }
    var users = await CustomUserSink()
        .getCustomUsersFromIds(ids: friends.map((e) => e.friendId).toList());

    return users;
  }
}

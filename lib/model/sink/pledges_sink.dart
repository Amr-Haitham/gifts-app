import 'package:cloud_firestore/cloud_firestore.dart';
import '../classes/pledge.dart';
import 'collection_names.dart';

class PledgesSink {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> setPledge({required Pledge pledge}) async {
    return _firebaseFirestore
        .collection(FirestoreCollectionNames.pledgesCollection)
        .doc(pledge.id)
        .set(pledge.toJson());
  }

  Future<Pledge?> getSinglePledgeFromGiftId({required String giftId}) async {
    var snapshot = await _firebaseFirestore
        .collection(FirestoreCollectionNames.pledgesCollection)
        .where('giftId', isEqualTo: giftId)
        .get();
    if (snapshot.docs.isEmpty) {
      return null;
    }
    return Pledge.fromJson(snapshot.docs.first.data());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllPledgesForUser(
      {required String userId}) async {
    return _firebaseFirestore
        .collection(FirestoreCollectionNames.pledgesCollection)
        .where('userId', isEqualTo: userId)
        .get();
  }
}

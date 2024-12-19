import 'package:cloud_firestore/cloud_firestore.dart';

import 'collection_names.dart';
import '../classes/gift.dart';

class GiftsSink {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  setGift({required Gift gift}) {
   return _firestore.collection(FirestoreCollectionNames.giftsCollection).doc(gift.id).set(gift.toJson());
  }

  deleteGift({required String giftId}) {
    return _firestore.collection(FirestoreCollectionNames.giftsCollection).doc(giftId).delete();
  }

  Future<List<Gift>> getAllGiftsForEvent({required String eventId}) async {
    var snapshot = await _firestore
        .collection(FirestoreCollectionNames.giftsCollection)
        .where('eventId', isEqualTo: eventId)
        .get();
    List<Gift> gifts = [];

    for (var doc in snapshot.docs) {
      gifts.add(Gift.fromJson(doc.data()));
    }
    return gifts;
  }

  Future<Gift> getSinglegift({required String giftId}) async {
    var snapshot = await _firestore
        .collection(FirestoreCollectionNames.giftsCollection)
        .doc(giftId)
        .get();
    return Gift.fromJson(snapshot.data() as Map<String, dynamic>);
  }
}

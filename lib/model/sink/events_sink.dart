import 'package:cloud_firestore/cloud_firestore.dart';

import '../classes/event.dart';
import 'collection_names.dart';

class EventsSink {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  setEvent({required Event event}) {
    return _firestore
        .collection(FirestoreCollectionNames.eventsCollection)
        .doc(event.id)
        .set(event.toJson());
  }

  deleteEvent({required String eventId}) {
    return _firestore
        .collection(FirestoreCollectionNames.eventsCollection)
        .doc(eventId)
        .delete();
  }

  Future<Event> getSingleEvent({required String eventId}) async {
    DocumentSnapshot snapshot = await _firestore
        .collection(FirestoreCollectionNames.eventsCollection)
        .doc(eventId)
        .get();
    return Event.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  Future<List<Event>> getAllEventsForCustomUser({required String uid}) async {
    var snapshot = await _firestore
        .collection(FirestoreCollectionNames.eventsCollection)
        .where('userId', isEqualTo: uid)
        .get();
    List<Event> events = [];

    for (var doc in snapshot.docs) {
      events.add(Event.fromJson(doc.data()));
    }
    return events;
  }
}

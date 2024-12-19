import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gifts_app/model/classes/custom_user.dart';
import 'package:meta/meta.dart';
import '../../model/classes/event.dart';
import '../../model/sink/events_sink.dart';
import '../../model/sink/friends_sink.dart';


class GetHomeScreenEventsUseCase {
  final EventsSink _eventsSink;
  final FriendsSink _friendsSink;

  GetHomeScreenEventsUseCase(this._eventsSink, this._friendsSink);

  Future<Map<CustomUser, Event>> execute(String userId) async {
    try {
      var allMyFriends = await _friendsSink.getAllFriendsForCustomUser(uid: userId);
      Map<CustomUser, Event> friendToEvent = {};

      for (var friend in allMyFriends) {
        List<Event> events = await _eventsSink.getAllEventsForCustomUser(uid: friend.id);
        if (events.isNotEmpty) {
          events.sort((a, b) => b.date.toDate().compareTo(a.date.toDate()));
          friendToEvent[friend] = events.first;
        }
      }

      return friendToEvent;
    } catch (e) {
      throw Exception("Failed to get latest events for friends");
    }
  }
}

class GetHomeScreenEvents extends Cubit<GetHomeScreenEventsState> {
  final GetHomeScreenEventsUseCase _GetHomeScreenEventsUseCase;

  GetHomeScreenEvents(this._GetHomeScreenEventsUseCase) : super(GetHomeScreenEventsInitial());

  void getHomeScreenEvents() async {
    emit(GetHomeScreenEventsLoading());
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      Map<CustomUser, Event> friendToEvent = await _GetHomeScreenEventsUseCase.execute(userId);
      emit(GetHomeScreenEventsLoaded(friendToEvent: friendToEvent));
    } catch (e) {
      emit(GetHomeScreenEventsError());
    }
  }
}

@immutable
abstract class GetHomeScreenEventsState {}

class GetHomeScreenEventsInitial extends GetHomeScreenEventsState {}

class GetHomeScreenEventsLoading extends GetHomeScreenEventsState {}

class GetHomeScreenEventsLoaded extends GetHomeScreenEventsState {
  final Map<CustomUser, Event> friendToEvent;

  GetHomeScreenEventsLoaded({required this.friendToEvent});
}

class GetHomeScreenEventsError extends GetHomeScreenEventsState {}

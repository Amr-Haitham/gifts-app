import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../model/classes/event.dart';
import '../../model/sink/events_sink.dart';


class GetUserEventsUseCase {
  final EventsSink _eventsSink;

  GetUserEventsUseCase(this._eventsSink);

  Future<List<Event>> execute(String uid) async {
    try {
      return await _eventsSink.getAllEventsForCustomUser(uid: uid);
    } catch (e) {
      throw Exception("Failed to get events for user");
    }
  }
}

class GetUserEventsCubit extends Cubit<GetUserEventsState> {
  final GetUserEventsUseCase _getUserEventsUseCase;

  GetUserEventsCubit(this._getUserEventsUseCase) : super(GetUserEventsInitial());

  void getUserEvents({required String uid}) async {
    emit(GetUserEventsLoading());
    try {
      List<Event> events = await _getUserEventsUseCase.execute(uid);
      emit(GetUserEventsLoaded(events: events));
    } catch (e) {
      emit(GetUserEventsError());
    }
  }
}

@immutable
abstract class GetUserEventsState {}

class GetUserEventsInitial extends GetUserEventsState {}

class GetUserEventsLoading extends GetUserEventsState {}

class GetUserEventsLoaded extends GetUserEventsState {
  final List<Event> events;

  GetUserEventsLoaded({required this.events});
}

class GetUserEventsError extends GetUserEventsState {}

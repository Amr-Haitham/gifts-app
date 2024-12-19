import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../model/sink/events_sink.dart';

class DeleteEventUseCase {
  final EventsSink _eventsSink;

  DeleteEventUseCase(this._eventsSink);

  Future<void> execute(String eventId) async {
    try {
      await _eventsSink.deleteEvent(eventId: eventId);
    } catch (e) {
      throw Exception("Failed to delete event");
    }
  }
}

class DeleteEventCubit extends Cubit<DeleteEventState> {
  final DeleteEventUseCase _deleteEventUseCase;

  DeleteEventCubit(this._deleteEventUseCase) : super(DeleteEventInitial());

  void deleteEvent({required String eventId}) async {
    try {
      emit(DeleteEventLoading());
      await _deleteEventUseCase.execute(eventId);
      emit(DeleteEventLoaded(eventId: eventId));
    } catch (e) {
      emit(DeleteEventError());
    }
  }
}

@immutable
abstract class DeleteEventState {}

class DeleteEventInitial extends DeleteEventState {}

class DeleteEventLoading extends DeleteEventState {}

class DeleteEventLoaded extends DeleteEventState {
  final String eventId;

  DeleteEventLoaded({required this.eventId});
}

class DeleteEventError extends DeleteEventState {}

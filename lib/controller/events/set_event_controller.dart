import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../model/classes/event.dart';
import '../../model/sink/events_sink.dart';

class SetEventUseCase {
  final EventsSink _eventsSink;

  SetEventUseCase(this._eventsSink);

  Future<void> execute(Event event) async {
    try {
      await _eventsSink.setEvent(event: event);
    } catch (e) {
      throw Exception("Failed to set event");
    }
  }
}

class SetEventCubit extends Cubit<SetEventState> {
  final SetEventUseCase _setEventUseCase;

  SetEventCubit(this._setEventUseCase) : super(SetEventInitial());

  void setEvent(Event event) async {
    emit(SetEventLoading());
    try {
      await _setEventUseCase.execute(event);
      emit(SetEventLoaded(event: event));
    } catch (e) {
      emit(SetEventError());
    }
  }
}

@immutable
abstract class SetEventState {}

class SetEventInitial extends SetEventState {}

class SetEventLoading extends SetEventState {}

class SetEventLoaded extends SetEventState {
  final Event event;

  SetEventLoaded({required this.event});
}

class SetEventError extends SetEventState {}

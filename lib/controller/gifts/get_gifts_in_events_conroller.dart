import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../model/classes/gift.dart';
import '../../model/sink/gifts_sink.dart';


class GetGiftsForEventUseCase {
  final GiftsSink _giftsSink;

  GetGiftsForEventUseCase(this._giftsSink);

  Future<List<Gift>> execute(String eventId) async {
    try {
      return await _giftsSink.getAllGiftsForEvent(eventId: eventId);
    } catch (e) {
      throw Exception("Failed to get gifts for event");
    }
  }
}

class GetGiftsForEventCubit extends Cubit<GetGiftsForEventState> {
  final GetGiftsForEventUseCase _getGiftsForEventUseCase;

  GetGiftsForEventCubit(this._getGiftsForEventUseCase) : super(GetGiftsForEventInitial());

  Future<void> getGiftsForEvent({required String eventId}) async {
    emit(GetGiftsForEventLoading());
    try {
      final gifts = await _getGiftsForEventUseCase.execute(eventId);
      emit(GetGiftsForEventLoaded(gifts: gifts));
    } catch (e) {
      emit(GetGiftsForEventError());
    }
  }
}

@immutable
abstract class GetGiftsForEventState {}

class GetGiftsForEventInitial extends GetGiftsForEventState {}

class GetGiftsForEventLoading extends GetGiftsForEventState {}

class GetGiftsForEventLoaded extends GetGiftsForEventState {
  final List<Gift> gifts;

  GetGiftsForEventLoaded({required this.gifts});
}

class GetGiftsForEventError extends GetGiftsForEventState {}

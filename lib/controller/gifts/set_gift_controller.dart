import 'package:bloc/bloc.dart';
import 'package:gifts_app/model/sink/gifts_sink.dart';
import 'package:meta/meta.dart';
import '../../model/classes/gift.dart';

class SetGiftForEventUseCase {
  final GiftsSink _giftsSink;

  SetGiftForEventUseCase(this._giftsSink);

  Future<void> execute(Gift gift) async {
    try {
      await _giftsSink.setGift(gift: gift);
    } catch (e) {
      throw Exception("Failed to set gift for event");
    }
  }
}

class SetGiftForEventCubit extends Cubit<SetGiftForEventState> {
  final SetGiftForEventUseCase _setGiftForEventUseCase;

  SetGiftForEventCubit(this._setGiftForEventUseCase) : super(SetGiftForEventInitial());

  void setGift({required Gift gift}) async {
    emit(SetGiftForEventLoading());
    try {
      await _setGiftForEventUseCase.execute(gift);
      emit(SetGiftForEventLoaded());
    } catch (e) {
      emit(SetGiftForEventError());
    }
  }
}

@immutable
abstract class SetGiftForEventState {}

class SetGiftForEventInitial extends SetGiftForEventState {}

class SetGiftForEventLoading extends SetGiftForEventState {}

class SetGiftForEventLoaded extends SetGiftForEventState {}

class SetGiftForEventError extends SetGiftForEventState {}

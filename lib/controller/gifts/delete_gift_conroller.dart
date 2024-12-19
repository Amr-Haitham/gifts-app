import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../model/sink/gifts_sink.dart';


class DeleteGiftForEventUseCase {
  final GiftsSink _giftsSink;

  DeleteGiftForEventUseCase(this._giftsSink);

  Future<void> execute(String giftId) async {
    try {
      await _giftsSink.deleteGift(giftId: giftId);
    } catch (e) {
      throw Exception("Failed to delete gift for event");
    }
  }
}

class DeleteGiftForEventCubit extends Cubit<DeleteGiftForEventState> {
  final DeleteGiftForEventUseCase _deleteGiftForEventUseCase;

  DeleteGiftForEventCubit(this._deleteGiftForEventUseCase) : super(DeleteGiftForEventInitial());

  void deleteGiftForEvent({required String giftId}) async {
    emit(DeleteGiftForEventLoading());
    try {
      await _deleteGiftForEventUseCase.execute(giftId);
      emit(DeleteGiftForEventLoaded());
    } catch (e) {
      emit(DeleteGiftForEventError());
    }
  }
}

@immutable
abstract class DeleteGiftForEventState {}

class DeleteGiftForEventInitial extends DeleteGiftForEventState {}

class DeleteGiftForEventLoading extends DeleteGiftForEventState {}

class DeleteGiftForEventLoaded extends DeleteGiftForEventState {}

class DeleteGiftForEventError extends DeleteGiftForEventState {}

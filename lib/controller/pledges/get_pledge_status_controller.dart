import 'package:bloc/bloc.dart';
import 'package:gifts_app/model/classes/custom_user.dart';
import 'package:gifts_app/model/sink/custom_user_sink.dart';
import 'package:meta/meta.dart';
import '../../model/classes/event.dart';
import '../../model/sink/events_sink.dart';
import '../../model/sink/gifts_sink.dart';
import '../../model/sink/pledges_sink.dart';

class GetPledgeStatusForGiftUseCase {
  final EventsSink _eventsSink;
  final PledgesSink _pledgesSink;
  final GiftsSink _giftsSink;
  final CustomUserSink _appUserSink;

  GetPledgeStatusForGiftUseCase(
      this._eventsSink, this._pledgesSink, this._giftsSink, this._appUserSink);

  Future<PledgeStatusData> execute(String giftId, String eventId) async {
    try {
      Event event = await _eventsSink.getSingleEvent(eventId: eventId);
      String userId = event.userId;

      var pledge = await _pledgesSink.getSinglePledgeFromGiftId(giftId: giftId);
      PledgeStatus pledgeStatus = PledgeStatus.unpledged;
      if (pledge != null) {
        pledgeStatus =
            pledge.isFulfilled ? PledgeStatus.done : PledgeStatus.pledged;
      }

      return PledgeStatusData(pledgeStatus: pledgeStatus, giftOwnerID: userId);
    } catch (e) {
      throw Exception("Failed to get pledge status for gift");
    }
  }
}

class GetPledgeStatusForGiftCubit extends Cubit<GetPledgeStatusForGiftState> {
  final GetPledgeStatusForGiftUseCase _getPledgeStatusForGiftUseCase;

  GetPledgeStatusForGiftCubit(this._getPledgeStatusForGiftUseCase)
      : super(GetPledgeStatusForGiftInitial());

  void getPledgeStatusForGift(
      {required String giftId, required String eventId}) async {
    emit(GetPledgeStatusForGiftLoading());
    try {
      PledgeStatusData statusData =
          await _getPledgeStatusForGiftUseCase.execute(giftId, eventId);
      print(statusData.pledgeStatus);
      print("meoweww");
      emit(GetPledgeStatusForGiftSuccess(
        pledgeStatus: statusData.pledgeStatus,
        giftOwnerID: statusData.giftOwnerID,
      ));
    } catch (e) {
      emit(GetPledgeStatusForGiftError());
    }
  }
}

@immutable
abstract class GetPledgeStatusForGiftState {}

class GetPledgeStatusForGiftInitial extends GetPledgeStatusForGiftState {}

class GetPledgeStatusForGiftLoading extends GetPledgeStatusForGiftState {}

class GetPledgeStatusForGiftSuccess extends GetPledgeStatusForGiftState {
  final PledgeStatus pledgeStatus;
  final String giftOwnerID;

  GetPledgeStatusForGiftSuccess(
      {required this.pledgeStatus, required this.giftOwnerID});
}

class GetPledgeStatusForGiftError extends GetPledgeStatusForGiftState {}

class PledgeStatusData {
  final PledgeStatus pledgeStatus;
  final String giftOwnerID;

  PledgeStatusData({required this.pledgeStatus, required this.giftOwnerID});
}

enum PledgeStatus {
  unpledged,
  pledged,
  done,
}

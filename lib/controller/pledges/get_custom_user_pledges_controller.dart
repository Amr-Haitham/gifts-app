// Use case class to handle business logic
import 'package:bloc/bloc.dart';
import 'package:gifts_app/model/classes/custom_user.dart';
import 'package:gifts_app/model/sink/custom_user_sink.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import '../../model/classes/gift.dart';
import '../../model/classes/notification.dart';
import '../../model/classes/pledge.dart';
import '../../model/sink/gifts_sink.dart';
import '../../model/sink/notifications_sink.dart';
import '../../model/sink/pledges_sink.dart';

class CommitmentUseCase {
  final PledgesSink _pledgesSink = PledgesSink();
  final NotificationsSink _notificationsSink = NotificationsSink();

  Future<void> execute({required Pledge pledge}) async {
    await _pledgesSink.setPledge(pledge: pledge);
    await _notificationsSink.setNotification(
      userId: pledge.giftOwnerId,
      notification: Notification(
        id: const Uuid().v4(),
        title: 'New Pledge!',
        body: 'You have a new pledge by user with id: ${pledge.userId}',
        createdAt: DateTime.now(),
      ),
    );
  }
}

class UserPledgesUseCase {
  final PledgesSink _pledgesSink = PledgesSink();
  final GiftsSink _giftsSink = GiftsSink();
  final CustomUserSink _customUserSink = CustomUserSink();

  Future<List<PledgeActualDataEntity>> fetchUserPledges(
      {required String userId}) async {
    List<PledgeActualDataEntity> pledges = [];
    final pledgesDocs = await _pledgesSink.getAllPledgesForUser(userId: userId);

    for (var pledgeDoc in pledgesDocs.docs) {
      final pledge = Pledge.fromJson(pledgeDoc.data());
      final appUser =
          await _customUserSink.getSingleCustomUser(pledge.giftOwnerId);
      final gift = await _giftsSink.getSinglegift(giftId: pledge.giftId);
      pledges.add(PledgeActualDataEntity(
          pledge: pledge, giftOwner: appUser, gift: gift));
    }

    return pledges;
  }
}

class PledgeActualDataEntity {
  final Pledge pledge;
  final CustomUser giftOwner;
  final Gift gift;

  PledgeActualDataEntity(
      {required this.pledge, required this.giftOwner, required this.gift});
}

class CommitmentCubit extends Cubit<CommitmentState> {
  CommitmentCubit(this._useCase) : super(CommitmentInitial());
  final CommitmentUseCase _useCase;

  void commitPledge({required Pledge pledge}) async {
    emit(CommitmentLoading());
    try {
      await _useCase.execute(pledge: pledge);
      emit(CommitmentSuccess());
    } catch (e) {
      emit(CommitmentError());
    }
  }
}

class UserPledgesCubit extends Cubit<UserPledgesState> {
  UserPledgesCubit(this._useCase) : super(UserPledgesInitial());
  final UserPledgesUseCase _useCase;

  void getUserPledges({required String userId}) async {
    emit(UserPledgesLoading());
    try {
      final pledges = await _useCase.fetchUserPledges(userId: userId);
      emit(UserPledgesSuccess(pledges: pledges));
    } catch (e) {
      emit(UserPledgesError());
    }
  }
}

// States for the CommitmentCubit
@immutable
abstract class CommitmentState {}

class CommitmentInitial extends CommitmentState {}

class CommitmentLoading extends CommitmentState {}

class CommitmentSuccess extends CommitmentState {}

class CommitmentError extends CommitmentState {}

// States for the UserPledgesCubit
@immutable
abstract class UserPledgesState {}

class UserPledgesInitial extends UserPledgesState {}

class UserPledgesLoading extends UserPledgesState {}

class UserPledgesSuccess extends UserPledgesState {
  final List<PledgeActualDataEntity> pledges;

  UserPledgesSuccess({required this.pledges});
}

class UserPledgesError extends UserPledgesState {}

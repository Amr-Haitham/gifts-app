// Use case class to handle business logic
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import '../../model/classes/notification.dart';
import '../../model/classes/pledge.dart';
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
        title: 'New Commitment!',
        body: 'You have a new commitment',
        createdAt: DateTime.now(),
      ),
    );
  }
}

// Separate cubit to handle the use case
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

// States for the CommitmentCubit
@immutable
abstract class CommitmentState {}

class CommitmentInitial extends CommitmentState {}

class CommitmentLoading extends CommitmentState {}

class CommitmentSuccess extends CommitmentState {}

class CommitmentError extends CommitmentState {}

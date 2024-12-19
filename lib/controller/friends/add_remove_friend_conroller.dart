import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../model/classes/friend.dart';
import '../../model/sink/friendship_sink.dart';


class FollowUnfollowUseCase {
  final FriendshipSink _friendshipSink;

  FollowUnfollowUseCase(this._friendshipSink);

  Future<void> addFriend(Friend friend) async {
    try {
      await _friendshipSink.addFriend(friend: friend);
    } catch (e) {
      throw Exception("Failed to add friend");
    }
  }

  Future<void> removeFriend(String friendId) async {
    try {
      List<Friend> friends = await _friendshipSink.getAllFriends();
      Friend friend = friends.firstWhere((f) => f.friendId == friendId);
      await _friendshipSink.removeFriend(id: friend.id);
    } catch (e) {
      throw Exception("Failed to remove friend");
    }
  }
}

class FollowUnfollowCubit extends Cubit<FollowUnfollowState> {
  final FollowUnfollowUseCase _followUnfollowUseCase;

  FollowUnfollowCubit(this._followUnfollowUseCase) : super(FollowUnfollowInitial());

  void addFriend({required Friend friend}) async {
    emit(FollowUnfollowLoading());
    try {
      await _followUnfollowUseCase.addFriend(friend);
      emit(FollowUnfollowSuccess());
    } catch (e) {
      emit(FollowUnfollowError());
    }
  }

  void removeFriend({required String friendId}) async {
    emit(FollowUnfollowLoading());
    try {
      await _followUnfollowUseCase.removeFriend(friendId);
      emit(FollowUnfollowSuccess());
    } catch (e) {
      emit(FollowUnfollowError());
    }
  }
}

@immutable
abstract class FollowUnfollowState {}

class FollowUnfollowInitial extends FollowUnfollowState {}

class FollowUnfollowLoading extends FollowUnfollowState {}

class FollowUnfollowSuccess extends FollowUnfollowState {}

class FollowUnfollowError extends FollowUnfollowState {}

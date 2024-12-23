import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import '../../model/classes/friend.dart';
import '../../model/sink/friendship_sink.dart';

class GetAllFriendsUseCase {
  final FriendshipSink _friendshipSink;

  GetAllFriendsUseCase(this._friendshipSink);

  Future<List<Friend>> execute({required String uid}) async {
    try {
      return await _friendshipSink.getAllFriends(uid: uid);
    } catch (e) {
      throw Exception("Failed to get all friends");
    }
  }
}

class GetAllFriendsCubit extends Cubit<GetAllFriendsState> {
  final GetAllFriendsUseCase _getAllFriendsUseCase;

  GetAllFriendsCubit(this._getAllFriendsUseCase)
      : super(GetAllFriendsInitial());

  void getAllFriends() async {
    emit(GetAllFriendsLoading());
    try {
      List<Friend> friends = await _getAllFriendsUseCase.execute(
          uid: FirebaseAuth.instance.currentUser!.uid);
      emit(GetAllFriendsLoaded(friends: friends));
    } catch (e) {
      emit(GetAllFriendsError());
    }
  }
}

@immutable
abstract class GetAllFriendsState {}

class GetAllFriendsInitial extends GetAllFriendsState {}

class GetAllFriendsLoading extends GetAllFriendsState {}

class GetAllFriendsLoaded extends GetAllFriendsState {
  final List<Friend> friends;

  GetAllFriendsLoaded({required this.friends});
}

class GetAllFriendsError extends GetAllFriendsState {}

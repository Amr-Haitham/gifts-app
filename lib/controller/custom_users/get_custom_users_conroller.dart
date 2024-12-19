import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../model/classes/custom_user.dart';
import '../../model/sink/custom_user_sink.dart';


class GetAllUsersUseCase {
  final CustomUserSink _customUserSink = CustomUserSink();

  Future<List<CustomUser>> fetchAllUsers() async {
    return await _customUserSink.getAllCustomUsers();
  }
}

class GetAllUsersCubit extends Cubit<GetAllUsersState> {
  GetAllUsersCubit(this._useCase) : super(GetAllUsersInitial());
  final GetAllUsersUseCase _useCase;

  void getAllUsers() async {
    emit(GetAllUsersLoading());
    try {
      final users = await _useCase.fetchAllUsers();
      emit(GetAllUsersLoaded(users: users));
    } catch (e) {
      print(e);
      emit(GetAllUsersError());
    }
  }
}

@immutable
abstract class GetAllUsersState {}

class GetAllUsersInitial extends GetAllUsersState {}

class GetAllUsersLoading extends GetAllUsersState {}

class GetAllUsersLoaded extends GetAllUsersState {
  final List<CustomUser> users;

  GetAllUsersLoaded({required this.users});
}

class GetAllUsersError extends GetAllUsersState {}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../model/classes/custom_user.dart';
import '../../model/sink/custom_user_sink.dart';

class GetAppUserUseCase {
  final CustomUserSink _customUserSink = CustomUserSink();

  Future<CustomUser> fetchAppUser({required String uid}) async {
    return await _customUserSink.getSingleCustomUser(uid);
  }
}

class GetAppUserCubit extends Cubit<GetAppUserState> {
  GetAppUserCubit(this._useCase) : super(GetAppUserInitial());
  final GetAppUserUseCase _useCase;

  void getAppUser({required String uid}) async {
    emit(GetAppUserLoading());
    try {
      final appUser = await _useCase.fetchAppUser(uid: uid);
      emit(GetAppUserLoaded(appUser: appUser));
    } catch (e) {
      print("$e the errror");
      emit(GetAppUserError());
    }
  }
}

@immutable
abstract class GetAppUserState {}

class GetAppUserInitial extends GetAppUserState {}

class GetAppUserLoading extends GetAppUserState {}

class GetAppUserLoaded extends GetAppUserState {
  final CustomUser appUser;

  GetAppUserLoaded({required this.appUser});
}

class GetAppUserError extends GetAppUserState {}

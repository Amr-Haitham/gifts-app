import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';

import '../../model/classes/custom_user.dart';
import '../../model/sink/custom_user_sink.dart';

class SetCustomUserUseCase {
  final CustomUserSink _customUserSink;

  SetCustomUserUseCase(this._customUserSink);

  Future<void> execute(CustomUser customUser) async {
    try {
      await _customUserSink.setSingleCustomUser(customUser);
    } catch (e) {
      throw Exception("Failed to set custom user");
    }
  }
}



class SetCustomUserCubit extends Cubit<SetCustomUserState> {
  final SetCustomUserUseCase _setCustomUserUseCase;

  SetCustomUserCubit(this._setCustomUserUseCase) : super(SetCustomUserInitial());

  void setCustomUser(CustomUser customUser) async {
    emit(SetCustomUserLoading());
    try {
      await _setCustomUserUseCase.execute(customUser);
      emit(SetCustomUserLoaded(customUser: customUser));
    } catch (e) {
      emit(SetCustomUserError());
    }
  }
}



@immutable
abstract class SetCustomUserState {}

class SetCustomUserInitial extends SetCustomUserState {}

class SetCustomUserLoading extends SetCustomUserState {}

class SetCustomUserLoaded extends SetCustomUserState {
  final CustomUser customUser;

  SetCustomUserLoaded({required this.customUser});
}

class SetCustomUserError extends SetCustomUserState {}

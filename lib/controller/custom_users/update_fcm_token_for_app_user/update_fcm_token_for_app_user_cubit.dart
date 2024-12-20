import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gifts_app/model/sink/custom_user_sink.dart';
import 'package:meta/meta.dart';

class UpdateFcmTokenForAppUserCubit
    extends Cubit<UpdateFcmTokenForAppUserState> {
  UpdateFcmTokenForAppUserCubit() : super(UpdateFcmTokenForAppUserInitial());
  final CustomUserSink _appUserRepo = CustomUserSink();
  Future<String?> getFcmToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission for notifications (iOS only)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get the FCM token
      String? token = await messaging.getToken();
      return token;
    } else {
      return null;
    }
  }

  void updateFcmToken({required String uid}) async {
    try {
      String? token = await getFcmToken();
      if (token == null) {
        emit(UpdateFcmTokenForAppUserError());
      } else {
        await _appUserRepo.updateFcmTokenForSingleAppUser(
            uid: uid, fcmToken: token);
        print("this is your token: $token");
        emit(UpdateFcmTokenForAppUserLoaded());
      }
    } catch (e) {
      print(e);
      emit(UpdateFcmTokenForAppUserError());
    }
  }
}

@immutable
sealed class UpdateFcmTokenForAppUserState {}

final class UpdateFcmTokenForAppUserInitial
    extends UpdateFcmTokenForAppUserState {}

final class UpdateFcmTokenForAppUserLoading
    extends UpdateFcmTokenForAppUserState {}

final class UpdateFcmTokenForAppUserLoaded
    extends UpdateFcmTokenForAppUserState {}

final class UpdateFcmTokenForAppUserError
    extends UpdateFcmTokenForAppUserState {}

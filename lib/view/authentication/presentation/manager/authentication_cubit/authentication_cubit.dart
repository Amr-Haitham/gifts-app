import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(UnAuthenticated(appIsStarting: true));
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool appIsStarting = true;
  //start the authentication stream to update ui based on it
  void startAuthenticationStream() {
    firebaseAuth.userChanges().listen((firebaseUser) {
      if (firebaseUser != null) {
        appIsStarting = false;
        emit(Authenticated(
          firebaseUser: firebaseUser,
        ));
      } else {
        emit(UnAuthenticated(appIsStarting: appIsStarting));
      }
    }, onError: (e) {
      print("error in $e");
      emit(AuthenticationError(message: e.toString()));
    });
  }

}

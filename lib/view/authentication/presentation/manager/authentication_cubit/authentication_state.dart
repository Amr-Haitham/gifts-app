// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'authentication_cubit.dart';

class AuthenticationState {}

class UnAuthenticated extends AuthenticationState {
  final bool appIsStarting;
  UnAuthenticated({
    required this.appIsStarting,
  });
}

class Authenticating extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {
  final String message;
  AuthenticationError({required this.message});
}

class Authenticated extends AuthenticationState {
  final User firebaseUser;

  Authenticated({
    required this.firebaseUser,
  });
}

part of 'authentication_op_cubit.dart';

@immutable
sealed class AuthenticationOpState {}

final class AuthenticationOpInitial extends AuthenticationOpState {}

final class AuthenticationOpLoaded extends AuthenticationOpState {
  final UserCredential userCredential;

  AuthenticationOpLoaded({required this.userCredential});
}

final class AuthenticationOpError extends AuthenticationOpState {
  final String errorMessage;

  AuthenticationOpError({required this.errorMessage});
}

final class AuthenticationOpLoading extends AuthenticationOpState {}

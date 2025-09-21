part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccessful extends LoginState {
  String message;
  LoginSuccessful({required this.message});
}

final class LoginFailure extends LoginState {
  String message;
  LoginFailure({required this.message});
}

final class LogOut extends LoginState {}

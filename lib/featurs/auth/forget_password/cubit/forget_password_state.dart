part of 'forget_password_cubit.dart';

@immutable
sealed class ForgetPasswordState {}

final class ForgetPasswordInitial extends ForgetPasswordState {}

class SendEmailLoading extends ForgetPasswordState {}

class SendEmailSuccess extends ForgetPasswordState {
  String message;
  SendEmailSuccess({required this.message});
}

class SendEmailFailure extends ForgetPasswordState {
  String message;
  SendEmailFailure({required this.message});
}

class SendOTPLoading extends ForgetPasswordState {}

class SendOTPSuccess extends ForgetPasswordState {
  String message;
  SendOTPSuccess({required this.message});
}

class SendOTPFailure extends ForgetPasswordState {
  String message;
  SendOTPFailure({required this.message});
}

class RestPassLoading extends ForgetPasswordState {}

class RestPassSuccess extends ForgetPasswordState {
  String message;
  RestPassSuccess({required this.message});
}

class RestPassFailure extends ForgetPasswordState {
  String message;
  RestPassFailure({required this.message});
}

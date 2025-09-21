part of 'register_cubit.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class ImageSelectedSuccess extends RegisterState {}

final class ImageNotSelected extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisteSuccess extends RegisterState {
  String message;
  RegisteSuccess({required this.message});
}

final class RegisterFailed extends RegisterState {
  String message;
  RegisterFailed({required this.message});
}

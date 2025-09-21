part of 'add_admin_cubit.dart';

@immutable
sealed class AddAdminState {}

final class AddAdminInitial extends AddAdminState {}

final class AddAdminLoading extends AddAdminState {}

final class AddAdminSuccess extends AddAdminState {
  String message;
  AddAdminSuccess({required this.message});
}

final class AddAdminFailed extends AddAdminState {
  String message;
  AddAdminFailed({required this.message});
}

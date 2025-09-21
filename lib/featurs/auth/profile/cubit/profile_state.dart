part of 'profile_cubit.dart';

@immutable
sealed class userProfileState {}

final class ProfileInitial extends userProfileState {}

final class ImageSelectedSuccess extends userProfileState {}

final class ImageNotSelected extends userProfileState {}

final class GetProfileLoading extends userProfileState {}

final class GetProfilesuccess extends userProfileState {
  String message;
  GetProfilesuccess({required this.message});
}

final class GetProfileFailed extends userProfileState {
  String message;
  GetProfileFailed({required this.message});
}

final class DeleteProfileLoading extends userProfileState {}

final class DeleteProfilesuccess extends userProfileState {
  String message;
  DeleteProfilesuccess({required this.message});
}

final class DeleteProfileFailed extends userProfileState {
  String message;
  DeleteProfileFailed({required this.message});
}

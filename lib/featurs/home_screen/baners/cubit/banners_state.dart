part of 'banners_cubit.dart';

@immutable
sealed class BannersState {}

final class ImageSelectedSuccess extends BannersState {}

final class ImageNotSelected extends BannersState {}

final class BannersInitial extends BannersState {}

final class GetBannersLoading extends BannersState {}

final class GetAllBannersSuccessful extends BannersState {
  String message;
  GetAllBannersSuccessful({required this.message});
}

final class GetBannersFailed extends BannersState {
  String message;
  GetBannersFailed({required this.message});
}

final class AddBannersLoading extends BannersState {}

final class AddBannersSuccessful extends BannersState {
  String message;
  AddBannersSuccessful({required this.message});
}

final class AddBannersFailed extends BannersState {
  String message;
  AddBannersFailed({required this.message});
}

final class EditBannerLoading extends BannersState {}

final class EditBannerSuccessful extends BannersState {
  String message;
  EditBannerSuccessful({required this.message});
}

final class EditBannerFailed extends BannersState {
  String message;
  EditBannerFailed({required this.message});
}

final class DeleteBannerLoading extends BannersState {}

final class DeleteBannerSuccessful extends BannersState {
  String message;
  DeleteBannerSuccessful({required this.message});
}

final class DeleteBannerFailed extends BannersState {
  String message;
  DeleteBannerFailed({required this.message});
}

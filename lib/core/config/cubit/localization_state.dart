part of 'localization_cubit.dart';

@immutable
sealed class LocalizationState {}

final class LocalizationInitial extends LocalizationState {}

final class Success extends LocalizationState {
  bool isArabic;
  Success(this.isArabic);
}

final class LogOut extends LocalizationState {}

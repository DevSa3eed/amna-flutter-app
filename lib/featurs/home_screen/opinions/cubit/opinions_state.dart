part of 'opinions_cubit.dart';

@immutable
sealed class OpinionsState {}

final class OpinionsInitial extends OpinionsState {}

final class GetOpinionsSuccess extends OpinionsState {
  String message;
  GetOpinionsSuccess({required this.message});
}

final class GetOpinionsFailed extends OpinionsState {
  String message;
  GetOpinionsFailed({required this.message});
}

final class GetOpinionsloading extends OpinionsState {}

final class AddOpinionsSuccess extends OpinionsState {
  String message;
  AddOpinionsSuccess({required this.message});
}

final class AddOpinionsFailed extends OpinionsState {
  String message;
  AddOpinionsFailed({required this.message});
}

final class AddOpinionsloading extends OpinionsState {}

final class EditOpinionsSuccess extends OpinionsState {
  String message;
  EditOpinionsSuccess({required this.message});
}

final class EditOpinionsFailed extends OpinionsState {
  String message;
  EditOpinionsFailed({required this.message});
}

final class EditOpinionsloading extends OpinionsState {}

final class DeleteOpinionsSuccess extends OpinionsState {
  String message;
  DeleteOpinionsSuccess({required this.message});
}

final class DeleteOpinionsFailed extends OpinionsState {
  String message;
  DeleteOpinionsFailed({required this.message});
}

final class DeleteOpinionsloading extends OpinionsState {}

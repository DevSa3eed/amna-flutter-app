part of 'teams_cubit.dart';

@immutable
sealed class TeamsState {}

final class ImageSelectedSuccess extends TeamsState {}

final class ImageNotSelected extends TeamsState {}

final class TeamsInitial extends TeamsState {}

final class TeamsLoading extends TeamsState {}

final class TeamsSuccess extends TeamsState {}

final class TeamsFailed extends TeamsState {}

final class AddTeamsLoading extends TeamsState {}

final class AddTeamsSuccess extends TeamsState {
  String message;
  AddTeamsSuccess({required this.message});
}

final class AddTeamsFailed extends TeamsState {
  String message;
  AddTeamsFailed({required this.message});
}

final class UpdateTeamsLoading extends TeamsState {}

final class UpdateTeamsSuccess extends TeamsState {
  String message;
  UpdateTeamsSuccess({required this.message});
}

final class UpdateTeamsFailed extends TeamsState {
  String message;
  UpdateTeamsFailed({required this.message});
}

final class DeleteTeamsLoading extends TeamsState {}

final class DeleteTeamsSuccess extends TeamsState {
  String message;
  DeleteTeamsSuccess({required this.message});
}

final class DeleteTeamsFailed extends TeamsState {
  String message;
  DeleteTeamsFailed({required this.message});
}

class TeamsDeletedAndRefresh extends TeamsState {}

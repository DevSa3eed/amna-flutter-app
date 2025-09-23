part of 'meeting_cubit.dart';

@immutable
sealed class MeetingState {}

final class MeetingInitial extends MeetingState {}

final class GetRequestsLoading extends MeetingState {}

final class GetRequestsSuccess extends MeetingState {
  String message;
  GetRequestsSuccess({required this.message});
}

final class GetRequestsFailed extends MeetingState {
  String message;
  GetRequestsFailed({required this.message});
}

final class AddRequestsLoading extends MeetingState {}

final class AddRequestsSuccess extends MeetingState {
  String message;
  AddRequestsSuccess({required this.message});
}

final class AddRequestsFailed extends MeetingState {
  String message;
  AddRequestsFailed({required this.message});
}

final class UpdateRequestsLoading extends MeetingState {}

final class UpdateRequestsSuccess extends MeetingState {
  String message;
  UpdateRequestsSuccess({required this.message});
}

final class UpdateRequestsFailed extends MeetingState {
  String message;
  UpdateRequestsFailed({required this.message});
}

final class ApproveRequestsLoading extends MeetingState {}

final class ApproveRequestsSuccess extends MeetingState {
  String message;
  ApproveRequestsSuccess({required this.message});
}

final class ApproveRequestsFailed extends MeetingState {
  String message;
  ApproveRequestsFailed({required this.message});
}

final class UpdateRequestStatusPaymentLoading extends MeetingState {}

final class UpdateRequestStatusPaymentSuccess extends MeetingState {
  String message;
  UpdateRequestStatusPaymentSuccess({required this.message});
}

final class UpdateRequestStatusPaymentFailed extends MeetingState {
  String message;
  UpdateRequestStatusPaymentFailed({required this.message});
}

final class DeleteRequestsLoading extends MeetingState {}

final class DeleteRequestsSuccess extends MeetingState {
  String message;
  DeleteRequestsSuccess({required this.message});
}

final class DeleteRequestsFailed extends MeetingState {
  String message;
  DeleteRequestsFailed({required this.message});
}

final class CallSuccess extends MeetingState {}

final class CallFailed extends MeetingState {}

final class ConvertoLoading extends MeetingState {}

final class ConvertedSuccess extends MeetingState {}

final class ConvertedFailed extends MeetingState {}

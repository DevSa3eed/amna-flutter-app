part of 'notification_cubit.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationInitialized extends NotificationState {}

class NotificationPermissionDenied extends NotificationState {}

class NotificationSuccess extends NotificationState {
  final String message;

  const NotificationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}

class NotificationPendingLoaded extends NotificationState {
  final List<PendingNotificationRequest> notifications;

  const NotificationPendingLoaded(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

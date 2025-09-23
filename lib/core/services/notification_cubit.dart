import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification_service.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  /// Initialize notification service
  Future<void> initializeNotifications() async {
    emit(NotificationLoading());

    try {
      await NotificationService.initialize();
      final bool enabled = await NotificationService.areNotificationsEnabled();

      if (enabled) {
        emit(NotificationInitialized());
      } else {
        emit(NotificationPermissionDenied());
      }
    } catch (e) {
      log('Error initializing notifications: $e');
      emit(NotificationError(
          'Failed to initialize notifications: ${e.toString()}'));
    }
  }

  /// Request notification permissions
  Future<void> requestPermissions() async {
    emit(NotificationLoading());

    try {
      final bool granted = await NotificationService.requestPermissions();

      if (granted) {
        emit(NotificationInitialized());
      } else {
        emit(NotificationPermissionDenied());
      }
    } catch (e) {
      log('Error requesting notification permissions: $e');
      emit(NotificationError('Failed to request permissions: ${e.toString()}'));
    }
  }

  /// Schedule appointment reminders
  Future<void> scheduleAppointmentReminders({
    required String appointmentId,
    required String doctorName,
    required String appointmentTime,
    required DateTime scheduledDateTime,
  }) async {
    try {
      await NotificationService.scheduleAppointmentReminders(
        appointmentId: appointmentId,
        doctorName: doctorName,
        appointmentTime: appointmentTime,
        scheduledDateTime: scheduledDateTime,
      );

      emit(const NotificationSuccess(
          'Appointment reminders scheduled successfully'));
    } catch (e) {
      log('Error scheduling appointment reminders: $e');
      emit(NotificationError('Failed to schedule reminders: ${e.toString()}'));
    }
  }

  /// Send appointment confirmation
  Future<void> sendAppointmentConfirmation({
    required String appointmentId,
    required String doctorName,
    required String appointmentTime,
    required String meetingUrl,
  }) async {
    try {
      await NotificationService.sendAppointmentConfirmation(
        appointmentId: appointmentId,
        doctorName: doctorName,
        appointmentTime: appointmentTime,
        meetingUrl: meetingUrl,
      );

      emit(const NotificationSuccess('Appointment confirmation sent'));
    } catch (e) {
      log('Error sending appointment confirmation: $e');
      emit(NotificationError('Failed to send confirmation: ${e.toString()}'));
    }
  }

  /// Send payment confirmation
  Future<void> sendPaymentConfirmation({
    required String appointmentId,
    required double amount,
  }) async {
    try {
      await NotificationService.sendPaymentConfirmation(
        appointmentId: appointmentId,
        amount: amount,
      );

      emit(const NotificationSuccess('Payment confirmation sent'));
    } catch (e) {
      log('Error sending payment confirmation: $e');
      emit(NotificationError(
          'Failed to send payment confirmation: ${e.toString()}'));
    }
  }

  /// Send appointment cancellation
  Future<void> sendAppointmentCancellation({
    required String appointmentId,
    required String doctorName,
    required String appointmentTime,
  }) async {
    try {
      await NotificationService.sendAppointmentCancellation(
        appointmentId: appointmentId,
        doctorName: doctorName,
        appointmentTime: appointmentTime,
      );

      emit(const NotificationSuccess('Appointment cancellation sent'));
    } catch (e) {
      log('Error sending appointment cancellation: $e');
      emit(NotificationError('Failed to send cancellation: ${e.toString()}'));
    }
  }

  /// Send appointment reschedule
  Future<void> sendAppointmentReschedule({
    required String appointmentId,
    required String doctorName,
    required String oldTime,
    required String newTime,
  }) async {
    try {
      await NotificationService.sendAppointmentReschedule(
        appointmentId: appointmentId,
        doctorName: doctorName,
        oldTime: oldTime,
        newTime: newTime,
      );

      emit(const NotificationSuccess('Appointment reschedule sent'));
    } catch (e) {
      log('Error sending appointment reschedule: $e');
      emit(NotificationError('Failed to send reschedule: ${e.toString()}'));
    }
  }

  /// Cancel appointment notifications
  Future<void> cancelAppointmentNotifications(String appointmentId) async {
    try {
      await NotificationService.cancelAppointmentNotifications(appointmentId);
      emit(const NotificationSuccess('Appointment notifications cancelled'));
    } catch (e) {
      log('Error cancelling appointment notifications: $e');
      emit(
          NotificationError('Failed to cancel notifications: ${e.toString()}'));
    }
  }

  /// Get pending notifications
  Future<void> getPendingNotifications() async {
    try {
      final notifications = await NotificationService.getPendingNotifications();
      emit(NotificationPendingLoaded(notifications));
    } catch (e) {
      log('Error getting pending notifications: $e');
      emit(NotificationError(
          'Failed to get pending notifications: ${e.toString()}'));
    }
  }

  /// Clear success state
  void clearSuccess() {
    if (state is NotificationSuccess) {
      emit(NotificationInitialized());
    }
  }

  /// Clear error state
  void clearError() {
    if (state is NotificationError) {
      emit(NotificationInitialized());
    }
  }
}

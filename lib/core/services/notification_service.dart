import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

/// Comprehensive notification service for appointment reminders and updates
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  /// Initialize the notification service
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Initialize timezone
      tz.initializeTimeZones();

      // Android initialization settings
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization settings
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      final bool? initialized = await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      if (initialized == true) {
        // Request permissions
        if (Platform.isAndroid) {
          await _requestAndroidPermissions();
        }

        _initialized = true;
        debugPrint('Notification service initialized successfully');
      } else {
        debugPrint('Failed to initialize notification service');
      }
    } catch (e) {
      debugPrint('Error initializing notification service: $e');
      // Don't throw the error, just log it so the app can continue
    }
  }

  /// Request Android notification permissions
  static Future<void> _requestAndroidPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.requestNotificationsPermission();
    await androidImplementation?.requestExactAlarmsPermission();
  }

  /// Handle notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // TODO: Handle navigation based on notification type
  }

  /// Schedule appointment reminder notification
  static Future<void> scheduleAppointmentReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    if (!_initialized) {
      debugPrint('Notification service not initialized, skipping reminder');
      return;
    }

    try {
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'appointment_reminders',
            'Appointment Reminders',
            channelDescription: 'Notifications for upcoming appointments',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: payload,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      debugPrint('Appointment reminder scheduled for $scheduledTime');
    } catch (e) {
      debugPrint('Error scheduling appointment reminder: $e');
    }
  }

  /// Schedule multiple appointment reminders
  static Future<void> scheduleAppointmentReminders({
    required String appointmentId,
    required String doctorName,
    required String appointmentTime,
    required DateTime scheduledDateTime,
  }) async {
    final appointmentTimeFormatted = appointmentTime;

    // Schedule reminder 1 hour before
    await scheduleAppointmentReminder(
      id: int.parse('${appointmentId}1'),
      title: 'Appointment Reminder',
      body:
          'Your appointment with Dr. $doctorName is in 1 hour at $appointmentTimeFormatted',
      scheduledTime: scheduledDateTime.subtract(const Duration(hours: 1)),
      payload: 'appointment_reminder_1h_$appointmentId',
    );

    // Schedule reminder 30 minutes before
    await scheduleAppointmentReminder(
      id: int.parse('${appointmentId}2'),
      title: 'Appointment Starting Soon',
      body: 'Your appointment with Dr. $doctorName starts in 30 minutes',
      scheduledTime: scheduledDateTime.subtract(const Duration(minutes: 30)),
      payload: 'appointment_reminder_30m_$appointmentId',
    );

    // Schedule reminder 10 minutes before
    await scheduleAppointmentReminder(
      id: int.parse('${appointmentId}3'),
      title: 'Appointment Starting Now',
      body:
          'Your appointment with Dr. $doctorName is starting now. Please join the meeting.',
      scheduledTime: scheduledDateTime.subtract(const Duration(minutes: 10)),
      payload: 'appointment_reminder_10m_$appointmentId',
    );
  }

  /// Send immediate notification
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized) {
      debugPrint('Notification service not initialized, skipping notification');
      return;
    }

    try {
      await _notifications.show(
        id,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'immediate_notifications',
            'Immediate Notifications',
            channelDescription: 'Immediate notifications for app updates',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  /// Send appointment confirmation notification
  static Future<void> sendAppointmentConfirmation({
    required String appointmentId,
    required String doctorName,
    required String appointmentTime,
    required String meetingUrl,
  }) async {
    await showNotification(
      id: int.parse('${appointmentId}conf'),
      title: 'Appointment Confirmed!',
      body:
          'Your appointment with Dr. $doctorName at $appointmentTime has been confirmed. Meeting link: $meetingUrl',
      payload: 'appointment_confirmed_$appointmentId',
    );
  }

  /// Send payment confirmation notification
  static Future<void> sendPaymentConfirmation({
    required String appointmentId,
    required double amount,
  }) async {
    await showNotification(
      id: int.parse('${appointmentId}pay'),
      title: 'Payment Confirmed',
      body:
          'Your payment of \$${amount.toStringAsFixed(2)} has been processed successfully.',
      payload: 'payment_confirmed_$appointmentId',
    );
  }

  /// Send appointment cancellation notification
  static Future<void> sendAppointmentCancellation({
    required String appointmentId,
    required String doctorName,
    required String appointmentTime,
  }) async {
    await showNotification(
      id: int.parse('${appointmentId}cancel'),
      title: 'Appointment Cancelled',
      body:
          'Your appointment with Dr. $doctorName at $appointmentTime has been cancelled.',
      payload: 'appointment_cancelled_$appointmentId',
    );
  }

  /// Send appointment reschedule notification
  static Future<void> sendAppointmentReschedule({
    required String appointmentId,
    required String doctorName,
    required String oldTime,
    required String newTime,
  }) async {
    await showNotification(
      id: int.parse('${appointmentId}reschedule'),
      title: 'Appointment Rescheduled',
      body:
          'Your appointment with Dr. $doctorName has been rescheduled from $oldTime to $newTime.',
      payload: 'appointment_rescheduled_$appointmentId',
    );
  }

  /// Cancel specific notification
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancel all notifications for an appointment
  static Future<void> cancelAppointmentNotifications(
      String appointmentId) async {
    await _notifications.cancel(int.parse('${appointmentId}1'));
    await _notifications.cancel(int.parse('${appointmentId}2'));
    await _notifications.cancel(int.parse('${appointmentId}3'));
    await _notifications.cancel(int.parse('${appointmentId}conf'));
    await _notifications.cancel(int.parse('${appointmentId}pay'));
    await _notifications.cancel(int.parse('${appointmentId}cancel'));
    await _notifications.cancel(int.parse('${appointmentId}reschedule'));
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Get pending notifications
  static Future<List<PendingNotificationRequest>>
      getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  /// Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      return await androidImplementation?.areNotificationsEnabled() ?? false;
    }
    return true; // iOS permissions are handled during initialization
  }

  /// Request notification permissions
  static Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      return await androidImplementation?.requestNotificationsPermission() ??
          false;
    }
    return true; // iOS permissions are handled during initialization
  }
}

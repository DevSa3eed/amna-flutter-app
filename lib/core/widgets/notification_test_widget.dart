import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/notification_service.dart';
import '../theme/Colors/coluors.dart';
import '../theme/text_styles/text_styeles.dart';

/// Test widget for notification functionality
class NotificationTestWidget extends StatelessWidget {
  const NotificationTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Test Notifications',
          style: TextStyles.lightBlue20blod,
        ),
        backgroundColor: Colours.White,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await NotificationService.showNotification(
                  id: 1,
                  title: 'Test Notification',
                  body: 'This is a test notification from the app!',
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Test notification sent!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colours.DarkBlue,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Send Test Notification',
                style: TextStyles.white16blod,
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () async {
                final now = DateTime.now();
                final scheduledTime = now.add(const Duration(seconds: 5));

                await NotificationService.scheduleAppointmentReminder(
                  id: 2,
                  title: 'Scheduled Test',
                  body: 'This notification was scheduled 5 seconds ago!',
                  scheduledTime: scheduledTime,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Scheduled notification set for 5 seconds!'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Schedule Test Notification (5s)',
                style: TextStyles.white16blod,
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () async {
                await NotificationService.sendAppointmentConfirmation(
                  appointmentId: 'test123',
                  doctorName: 'Dr. Test',
                  appointmentTime: '2024-01-01 10:00',
                  meetingUrl: 'tel:+1234567890',
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Appointment confirmation sent!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Send Appointment Confirmation',
                style: TextStyles.white16blod,
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () async {
                await NotificationService.cancelAllNotifications();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All notifications cancelled!'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Cancel All Notifications',
                style: TextStyles.white16blod,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

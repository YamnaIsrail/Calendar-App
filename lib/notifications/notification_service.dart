import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:calendar_app/main.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz; // For initializing time zones
import 'package:timezone/timezone.dart' as tz;
import 'disable_battery_optimization.dart'; // For TZDateTime and timezone manipulation
import 'package:app_settings/app_settings.dart';


//ID 100+ loop for water, 2 for backup, 7-12 for periods, 13 for fertility window, 14 for Luteal Phase,
class NotificationService {
  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'your_channel_id', // Channel ID
      'Your Channel Name', // Channel Name
      description: 'This channel is used for notifications.',
      importance: Importance.high, // Set the importance level for the notifications
    );

    await flutterLocalNotification
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static final FlutterLocalNotificationsPlugin flutterLocalNotification =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    await requestNotificationPermission();
    await requestExactAlarmPermission();
    await disableBatteryOptimization();

    await _createNotificationChannel(); // Create the notification channel

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotification.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
    );

  }



  static Future<void> rscheduleNotification(
      int id, String title, String body, DateTime scheduledTime) async {


    await flutterLocalNotification.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id', // Use the same channel ID
          'Your Channel Name', // Use the same channel name
          channelDescription: 'This channel is used for notifications.',
          importance: Importance.max,
          priority: Priority.max,
          showWhen: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      // Remove this line to avoid daily repetition
      // matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> scheduleNotification(
      int id, String title, String body,
      DateTime scheduledTime) async {

    await flutterLocalNotification.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id', // Use the same channel ID
          'Your Channel Name', // Use the same channel name
          channelDescription: 'This channel is used for notifications.',
          importance: Importance.max,
          priority: Priority.max,
          showWhen: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }




  static Future<void> cancelScheduledTask(int notificationId) async {
    try {
      await flutterLocalNotification.cancel(notificationId);
    } catch (e) {
      debugPrint("Error canceling notification: $e");
    }
  }

  static Future<void> onDidReceiveNotification(NotificationResponse response) async {
    final context = navigatorKey.currentContext;
    if (context == null) return; // Prevent crashes

    if (response.payload == 'show_dialog') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Notification'),
            content: Text('This is a popup from the notification!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  static Future<void> showInstantNotification(String title, String body) async {
    const NotificationDetails platformChannels = NotificationDetails(
      android: AndroidNotificationDetails(
        "channelId",
        "channelName",
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
      ),
    );
    await flutterLocalNotification.show(0, title, body, platformChannels);
  }

  static Future<void> requestExactAlarmPermission() async {
    if (Platform.isAndroid) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  static Future<bool> requestNotificationPermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.notification.status;
      if (!status.isGranted) {
        var result = await Permission.notification.request();
        return result.isGranted;
      }
    }return true; // Assume permissions granted for other platforms
  }

}
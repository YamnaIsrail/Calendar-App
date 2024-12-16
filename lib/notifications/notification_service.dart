import 'package:calender_app/notifications/notification_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'notification_storage.dart';
import 'package:flutter/foundation.dart'; //

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotification =
  FlutterLocalNotificationsPlugin();

  // Handle notification taps (foreground and background)
  static Future<void> onDidRecieveNotification(
      NotificationResponse notificationResponse) async {
    if (notificationResponse.payload != null) {
      debugPrint('Notification payload: ${notificationResponse.payload}');
      // Perform action based on notification payload
    }
  }

  // Initialize the notification plugin
  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIos =
    DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIos,
    );

    await flutterLocalNotification.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: onDidRecieveNotification,
      onDidReceiveNotificationResponse: onDidRecieveNotification,
    );

    await flutterLocalNotification
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showInstantNotification(String title, String body) async {
    const NotificationDetails platformChannels = NotificationDetails(
      android: AndroidNotificationDetails(
        "channelId",
        "channelName",
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await flutterLocalNotification.show(0, title, body, platformChannels);
  }

  static Future<void> cancelNotification(String id) async {
    await flutterLocalNotification.cancel(id.hashCode);
  }

  static Future<void> showScheduleNotification({
    required String title,
    required String body,
    required DateTime scheduleDate,
    required int id,
    bool repeatDaily = false,
    bool repeatWeekly = false,
    bool repeatMonthly = false,
  }) async {
    const NotificationDetails platformChannels = NotificationDetails(
      android: AndroidNotificationDetails(
        "channelId",
        "channelName",
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotification.cancel(id);

    if (repeatDaily) {
      await flutterLocalNotification.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduleDate, tz.local),
        platformChannels,
        androidScheduleMode: AndroidScheduleMode.exact,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } else if (repeatWeekly) {
      await flutterLocalNotification.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduleDate, tz.local),
        platformChannels,
        androidScheduleMode: AndroidScheduleMode.exact,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    } else if (repeatMonthly) {
      await flutterLocalNotification.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduleDate, tz.local),
        platformChannels,
        androidScheduleMode: AndroidScheduleMode.exact,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
    } else {
      await flutterLocalNotification.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduleDate, tz.local),
        platformChannels,
        androidScheduleMode: AndroidScheduleMode.exact,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
    }

    NotificationStorage.saveNotification(NotificationModel(
      id: id,
      title: title,
      body: body,
      scheduleTime: scheduleDate,
    ));
  }

  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotification.cancelAll();
  }
}

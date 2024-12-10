  import 'package:calender_app/notifications/notification_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
  import 'package:timezone/timezone.dart' as tz;

import 'notification_storage.dart';
  class NotificationService {
    //Initialization FlutterLocalNotificationsPlugin instance
    static final FlutterLocalNotificationsPlugin flutterLocalNotification =
    FlutterLocalNotificationsPlugin();

    //
    static Future<void> onDidRecieveNotification(
        NotificationResponse notificationResponse) async {}

  //Initialization notification plugin
    static Future<void> init() async {
      //for android
      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
      //for ios
      const DarwinInitializationSettings initializationSettingsIos =
      DarwinInitializationSettings();
      //combine android+ios intialization
      const InitializationSettings initializationSettings =
      InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIos);
      //Initialize the plugin with specified settings
      await flutterLocalNotification.initialize(initializationSettings,
          onDidReceiveBackgroundNotificationResponse: onDidRecieveNotification,
          onDidReceiveNotificationResponse: onDidRecieveNotification);

  //Request notifications for android
      await flutterLocalNotification
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    //Show an instant Notification
    static Future<void> showInstantNotification(
        String title, String body) async {
      //define notification details
      const NotificationDetails platformChannels= NotificationDetails(
          android: AndroidNotificationDetails("channelId", "channelName", importance: Importance.high, priority: Priority.high),
          iOS: DarwinNotificationDetails()
      );
      await flutterLocalNotification.show(0, title, body, platformChannels);
    }

    //Show a schedule notification
    static Future<void> cancelNotification(String id) async {
      await flutterLocalNotification.cancel(id.hashCode); // Use hashCode for ID consistency
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

      // Cancel any previously scheduled notifications for this ID
      await flutterLocalNotification.cancel(id);

      if (repeatDaily) {
        // Schedule repeated daily notifications
        await flutterLocalNotification.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduleDate, tz.local),
          platformChannels,
          androidScheduleMode: AndroidScheduleMode.exact,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      } else if (repeatWeekly) {
        // Schedule weekly notifications
        await flutterLocalNotification.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduleDate, tz.local),
          platformChannels,
          androidScheduleMode: AndroidScheduleMode.exact,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
      } else if (repeatMonthly) {
        // Schedule monthly notifications
        await flutterLocalNotification.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduleDate, tz.local),
          platformChannels,
          androidScheduleMode: AndroidScheduleMode.exact,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dateAndTime,
        );
      } else {
        // Schedule a one-off notification
        await flutterLocalNotification.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduleDate, tz.local),
          platformChannels,
          androidScheduleMode: AndroidScheduleMode.exact,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dateAndTime,
        );
      }

      // Optionally save the notification details (if you're persisting them)

      NotificationStorage.saveNotification(NotificationModel(
        id: id,
        title: title,
        body: body,
        scheduleTime: scheduleDate,
      ));
    }

    // static Future<void> showScheduleNotification(
    //     String title, String body, DateTime scheduleDate, {required int id}) async {
    //   const NotificationDetails platformChannels = NotificationDetails(
    //     android: AndroidNotificationDetails("channelId", "channelName",
    //         importance: Importance.high, priority: Priority.high),
    //     iOS: DarwinNotificationDetails(),
    //   );
    //
    //   // Schedule the notification
    //   await flutterLocalNotification.zonedSchedule(
    //     id,
    //     title,
    //     body,
    //     tz.TZDateTime.from(scheduleDate, tz.local),
    //     platformChannels,
    //     uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    //     androidScheduleMode: AndroidScheduleMode.exact,
    //     matchDateTimeComponents: DateTimeComponents.dateAndTime,
    //   );
    //
    //   // Save the notification details to Hive
    //   NotificationStorage.saveNotification(NotificationModel(
    //     id: id,
    //     title: title,
    //     body: body,
    //     scheduleTime: scheduleDate,
    //   ));
    // }

    static Future<void> cancelAllNotifications() async {
      await flutterLocalNotification.cancelAll();
    }

  }
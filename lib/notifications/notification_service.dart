  import 'package:flutter_local_notifications/flutter_local_notifications.dart';
  import 'package:timezone/timezone.dart' as tz;
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
    static Future<void> showIScheduleNotification(
        String title, String body, DateTime  scheduleDate) async {
      //define notification details
      const NotificationDetails platformChannels= NotificationDetails(
          android: AndroidNotificationDetails("channelId", "channelName", importance: Importance.high, priority: Priority.high),
          iOS: DarwinNotificationDetails()
      );
      await flutterLocalNotification.zonedSchedule(0, title, body,
          tz.TZDateTime.from(scheduleDate, tz.local),
          platformChannels,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation
              .absoluteTime,
          androidScheduleMode: AndroidScheduleMode.exact,
          matchDateTimeComponents: DateTimeComponents.dateAndTime
      );
    }
  }
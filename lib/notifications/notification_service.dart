
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:calender_app/main.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest.dart' as tzData;

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotification =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tzData.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotification.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
    );
    await Workmanager().initialize(callbackDispatcher);
  }

  static Future<void> onDidReceiveNotification(NotificationResponse response) async {
    // Check the payload to determine what to do
    if (response.payload == 'show_dialog') {
      // Show a dialog when the notification is tapped
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Notification'),
            content: Text('This is a popup from the notification!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
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
      ),
    );
    await flutterLocalNotification.show(0, title, body, platformChannels);
  }

  static Future<void> scheduleBackgroundTask(
      String tag,
      Map<String, dynamic> inputData,
      DateTime scheduleDate,
      ) async {
    await Workmanager().registerOneOffTask(
      tag,
      "background_notification_task",
      inputData: inputData,
      initialDelay: scheduleDate.difference(DateTime.now()),
    );
  }

  static Future<void> cancelScheduledTask(String tag) async {
    await Workmanager().cancelByUniqueName(tag);
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (inputData != null) {
      String title = inputData['title'] ?? "Default Title";
      String body = inputData['body'] ?? "Default Body";

      const NotificationDetails platformChannels = NotificationDetails(
        android: AndroidNotificationDetails(
          "channelId",
          "channelName",
          importance: Importance.high,
          priority: Priority.high,
        ),
      );

      FlutterLocalNotificationsPlugin flutterLocalNotification =
      FlutterLocalNotificationsPlugin();
      await flutterLocalNotification.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        platformChannels,
      );
    }
    return Future.value(true);
  });
}

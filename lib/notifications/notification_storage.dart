import 'package:hive/hive.dart';
import 'package:calender_app/notifications/notification_model.dart';
import 'package:calender_app/screens/flow2/detail%20page/analysis/timeline/time_line_entry.dart';

import '../hive/timeline_entry.dart';

class NotificationStorage {
  static late Box<NotificationModel> notificationBox;
  static late Box<TimelineEntry> timelineBox; // Add the timelineBox here.

  /// Initialize Hive and open both the notifications and timeline boxes
  static Future<void> init() async {
    notificationBox = await Hive.openBox<NotificationModel>('notifications');
    timelineBox = await Hive.openBox<TimelineEntry>('timeline'); // Open timeline box
  }

  /// Save or Update a notification using unique id as the key
  static Future<void> saveNotification(NotificationModel notification) async {
    await notificationBox.put(notification.id, notification);
  }

  /// Save or Update a timeline entry
  static Future<void> saveTimelineEntry(TimelineEntry timelineEntry) async {
    await timelineBox.put(timelineEntry.id, timelineEntry);
  }

  /// Get all notifications stored in the database
  static List<NotificationModel> getNotifications() {
    return notificationBox.values.toList();
  }

  /// Get all timeline entries stored in the database
  static List<TimelineEntry> getTimelineEntries() {
    return timelineBox.values.toList();
  }

  /// Delete a notification by ID
  static Future<void> deleteNotification(int id) async {
    if (notificationBox.containsKey(id)) {
      await notificationBox.delete(id);
    }
  }

  /// Delete a timeline entry by ID
  static Future<void> deleteTimelineEntry(int id) async {
    if (timelineBox.containsKey(id)) {
      await timelineBox.delete(id);
    }
  }
}

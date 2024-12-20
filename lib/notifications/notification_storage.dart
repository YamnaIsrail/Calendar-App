import 'package:calender_app/notifications/notification_model.dart';
import 'package:hive/hive.dart';

class NotificationStorage {
  static late Box<NotificationModel> notificationBox;

  /// Initialize Hive and open the notifications box


  /// Save or Update a notification using unique id as the key
  static Future<void> saveNotification(NotificationModel notification) async {
    try {
      await notificationBox.put(notification.id, notification);
    } catch (e) {
      print("Error saving notification: $e");
    } // Save with ID as the key
  }

  /// Get all notifications stored in the database
  static List<NotificationModel> getNotifications() {
    return notificationBox.values.toList();  // Retrieve all notifications
  }

  /// Delete a notification by ID
  static Future<void> deleteNotification(int id) async {
    if (notificationBox.containsKey(id)) { // Check if the key exists
      await notificationBox.delete(id);
    }
  }
}
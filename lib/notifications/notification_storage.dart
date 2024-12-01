import 'package:calender_app/notifications/notification_model.dart';
import 'package:hive/hive.dart';

class NotificationStorage {
  static late Box<NotificationModel> notificationBox;

  static Future<void> init() async {
    notificationBox = await Hive.openBox<NotificationModel>('notifications');
  }

  static Future<void> saveNotification(NotificationModel notification) async {
    await notificationBox.add(notification);  // Save a new notification
  }

  static List<NotificationModel> getNotifications() {
    return notificationBox.values.toList();  // Retrieve all notifications
  }

  static Future<void> deleteNotification(int id) async {
    var notification = notificationBox.values.firstWhere((item) => item.id == id);
    await notification.delete();  // Delete notification by ID
  }
}

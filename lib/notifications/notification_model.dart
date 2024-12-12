import 'package:hive/hive.dart';

part 'notification_model.g.dart'; // This generates the TypeAdapter for the model.

@HiveType(typeId: 6)
class NotificationModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String body;

  @HiveField(3)
  final DateTime scheduleTime;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduleTime,
  });
}

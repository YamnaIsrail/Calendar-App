import 'package:hive/hive.dart';

part 'medicine_model.g.dart';

@HiveType(typeId: 2)
class MedicineReminder {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String time;

  @HiveField(2)
  final String date;

  MedicineReminder({required this.title, required this.time, required this.date});
}

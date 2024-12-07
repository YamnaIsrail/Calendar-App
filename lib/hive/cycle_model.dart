import 'package:hive/hive.dart';

part 'cycle_model.g.dart';
@HiveType(typeId: 1)
class CycleData {
  @HiveField(0)
  final String cycleStartDate;

  @HiveField(1)
  final String cycleEndDate;

  @HiveField(2)
  final int? periodLength;

  @HiveField(3)
  final int? cycleLength;

  @HiveField(4)
  final List<String> pastPeriods;  // Keep it as List<String> if you're storing date strings

  CycleData({
    required this.cycleStartDate,
    required this.cycleEndDate,
    required this.periodLength,
    required this.cycleLength,
    List<String>? pastPeriods,   // Make this nullable in the constructor
  }) : this.pastPeriods = pastPeriods ?? [];  // Initialize it with an empty list if null

  // Convert List<String> to List<DateTime>
  List<DateTime> get pastPeriodsAsDateTime =>
      pastPeriods.map((dateString) => DateTime.parse(dateString)).toList();

}

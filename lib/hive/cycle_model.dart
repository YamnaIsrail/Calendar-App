import 'package:hive/hive.dart';

part 'cycle_model.g.dart';

@HiveType(typeId: 1)
class CycleData {
  @HiveField(0)
  final String cycleStartDate;  // Last period start date

  @HiveField(1)
  final String cycleEndDate;    // Last period end date (calculated based on cycle length)

  @HiveField(2)
  final int? periodLength;       // Period length (number of days)

  @HiveField(3)
  final int? cycleLength;        // Cycle length (days in the menstrual cycle)

  CycleData({
    required this.cycleStartDate,
    required this.cycleEndDate,
    required this.periodLength,
    required this.cycleLength,
  });
}

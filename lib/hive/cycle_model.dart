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
  final List<Map<String, String>> pastPeriods; // Stores startDate and endDate as maps

  CycleData({
    required this.cycleStartDate,
    required this.cycleEndDate,
    this.periodLength,
    this.cycleLength,
    List<Map<String, String>>? pastPeriods,
  }) : this.pastPeriods = pastPeriods ?? []; // Initialize with empty list if null

  // Getter to convert List<Map<String, String>> to List<Map<String, DateTime>>
  List<Map<String, DateTime>> get pastPeriodsAsDateTime => pastPeriods.map((dateMap) {
    return {
      'startDate': DateTime.parse(dateMap['startDate']!),
      'endDate': DateTime.parse(dateMap['endDate']!),
    };
  }).toList();

  // Add a method to append a new period
  void addPeriod(DateTime startDate, DateTime endDate) {
    pastPeriods.add({
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    });
  }

  // Add a method to remove a period
  void removePeriod(DateTime startDate, DateTime endDate) {
    pastPeriods.removeWhere((period) =>
    period['startDate'] == startDate.toIso8601String() &&
        period['endDate'] == endDate.toIso8601String());
  }

  // Create a copy of the current object with updated fields
  CycleData copyWith({
    String? cycleStartDate,
    String? cycleEndDate,
    int? periodLength,
    int? cycleLength,
    List<Map<String, String>>? pastPeriods,
  }) {
    return CycleData(
      cycleStartDate: cycleStartDate ?? this.cycleStartDate,
      cycleEndDate: cycleEndDate ?? this.cycleEndDate,
      periodLength: periodLength ?? this.periodLength,
      cycleLength: cycleLength ?? this.cycleLength,
      pastPeriods: pastPeriods ?? this.pastPeriods,
    );
  }
}

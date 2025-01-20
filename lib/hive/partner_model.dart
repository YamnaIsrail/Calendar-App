import 'package:hive/hive.dart';

part 'partner_model.g.dart';

// Define the PartnerData class as a Hive model
@HiveType(typeId: 5)
class PartnerData extends HiveObject {
  @HiveField(0)
  DateTime cycleStartDate;

  @HiveField(1)
  int cycleLength;

  @HiveField(2)
  int periodLength;

  @HiveField(3)
  DateTime cycleEndDate;

  @HiveField(4)
  bool pregnancyMode;

  @HiveField(5)
  DateTime? gestationStart;

  @HiveField(6)
  List<Map<String, String>> pastPeriods;

  @HiveField(7)
  DateTime? dueDate;

  // Constructor to initialize the PartnerData object
  PartnerData({
    required this.cycleStartDate,
    required this.cycleLength,
    required this.periodLength,
    required this.cycleEndDate,
    required this.pregnancyMode,
    this.gestationStart,
    required this.pastPeriods,
    this.dueDate,
  });

  // Method to update cycle data
  void updatePartnerData({
    required DateTime cycleStartDate,
    required int cycleLength,
    required int periodLength,
    required DateTime cycleEndDate,
    required bool pregnancyMode,
    DateTime? gestationStart,
    required List<Map<String, String>> pastPeriods,
    DateTime? dueDate,
  }) {
    this.cycleStartDate = cycleStartDate;
    this.cycleLength = cycleLength;
    this.periodLength = periodLength;
    this.cycleEndDate = cycleEndDate;
    this.pregnancyMode = pregnancyMode;
    this.gestationStart = gestationStart;
    this.pastPeriods = pastPeriods;
    this.dueDate = dueDate;
  }
}

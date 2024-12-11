import 'package:hive/hive.dart';

part 'timeline_entry.g.dart'; // Ensure you run `build_runner` after this change.

@HiveType(typeId: 4) // Register type with Hive
class TimelineEntry extends HiveObject {
  @HiveField(0)
  final int id; // Unique identifier for persistence

  @HiveField(1)
  final DateTime date; // Holds the timestamp at the moment of creation

  @HiveField(2)
  final String type;

  @HiveField(3)
  final Map<String, dynamic> details;

  /// Constructor that sets date to current time when created
  TimelineEntry({
    required this.id,
    DateTime? date,
    required this.type,
    required this.details,
  }) : date = date ?? DateTime.now();

  /// Converts the object to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'type': type,
      'details': details,
    };
  }

  /// Factory method to convert database data back into an instance
  factory TimelineEntry.fromMap(Map<String, dynamic> map) {
    return TimelineEntry(
      id: map['id'],
      date: DateTime.parse(map['date']),
      type: map['type'],
      details: Map<String, dynamic>.from(map['details']),
    );
  }
}

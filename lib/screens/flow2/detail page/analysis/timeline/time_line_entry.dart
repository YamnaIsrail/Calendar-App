// class TimelineEntry {
//   final DateTime date; // Holds the timestamp at the moment of creation
//   final String type;
//   final Map<String, dynamic> details;
//
//   /// Constructor that sets date to current time when created
//   TimelineEntry({
//     DateTime? date, // optional parameter
//     required this.type,
//     required this.details,
//   }) : date = date ?? DateTime.now(); // Set current system time by default
//
//   /// Converts the object to a map for database storage
//   Map<String, dynamic> toMap() {
//     return {
//       'date': date.toIso8601String(),
//       'type': type,
//       'details': details,
//     };
//   }
//
//   /// Factory method to convert database data back into an instance
//   factory TimelineEntry.fromMap(Map<String, dynamic> map) {
//     return TimelineEntry(
//       date: DateTime.parse(map['date']),
//       type: map['type'],
//       details: Map<String, dynamic>.from(map['details']),
//     );
//   }
// }

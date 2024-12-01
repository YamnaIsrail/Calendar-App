class TimelineEntry {
  final String title; // Notification title or note
  final String description; // Notification body or note content
  final DateTime date; // Scheduled date or note date
  final String? mood; // Mood label, if applicable
  final String? symptom; // Symptom label, if applicable
  final String? type; // Symptom label, if applicable
  final String? content;
//
  TimelineEntry({
    required this.title,
    required this.description,
    required this.date,
    this.mood,
    this.symptom,
    this.content,
    this.type,
  });
}

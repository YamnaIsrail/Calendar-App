import 'package:hive/hive.dart';

part 'notes_model.g.dart';  // Required for Hive

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  @HiveField(2)
  DateTime date;

  // Add a default value for title if it's empty
  Note({
    required this.title,
    required this.content,
    required this.date,
  });

  // You can create a method to update content and optionally title or date
  void updateContent({String? newContent, String? newTitle, DateTime? newDate}) {
    if (newContent != null) content = newContent;
    if (newTitle != null) title = newTitle;
    if (newDate != null) date = newDate;
  }
}

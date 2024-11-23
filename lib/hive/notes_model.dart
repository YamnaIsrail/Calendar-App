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

  Note({
    required this.title,
    required this.content,
    required this.date,
  });

  // You can create a method to update content
  void updateContent(String newContent) {
    content = newContent;
  }
}

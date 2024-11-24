import 'package:hive/hive.dart';

part 'notes_model.g.dart';

@HiveType(typeId: 0) // Assign a unique type ID
class Note extends HiveObject {
  @HiveField(0)
  late final String content;

  Note({
    required this.content,
  });
}


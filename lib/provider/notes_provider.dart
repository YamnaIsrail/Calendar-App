import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../hive/notes_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../hive/notes_model.dart';

class NoteWithDate {
  final String content;
  final DateTime date;

  NoteWithDate({required this.content, required this.date});
}

class NoteProvider extends ChangeNotifier {
  List<NoteWithDate> notesWithDates = [];

  late Box<Note> _notesBox = Hive.box<Note>('notesBox');

  Future<void> initialize() async {
    _notesBox = Hive.box<Note>('notesBox');
    notesWithDates = _notesBox.values
        .map((note) => NoteWithDate(content: note.content, date: DateTime.now()))
        .toList();

    // Use addPostFrameCallback to avoid notifying listeners during the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }



  void addNote(String content) {
    final newNote = NoteWithDate(content: content, date: DateTime.now());
    _notesBox.add(Note(content: content));
    notesWithDates.add(newNote);
    notifyListeners();
  }

  void updateNoteAt(int index, String updatedContent) {
    final updatedNote = notesWithDates[index];
    notesWithDates[index] =
        NoteWithDate(content: updatedContent, date: updatedNote.date);
    _notesBox.putAt(index, Note(content: updatedContent));
    notifyListeners();
  }

  void deleteNoteAt(int index) {
    _notesBox.deleteAt(index);
    notesWithDates.removeAt(index);
    notifyListeners();
  }
}
//
// // Model to pair notes with dates
// class NoteWithDate {
//   final Note note;
//   final DateTime date;
//   String get content => note.content; // Access the content directly from the note
//
//   NoteWithDate({required this.note, required this.date});
// }

//
// class NoteProvider with ChangeNotifier {
//   late Box<Note> _notesBox;
//
//   List<Note> get notes => _notesBox.values.toList();
//
//   // Initialize the provider
//   Future<void> initialize() async {
//     _notesBox = Hive.box<Note>('notesBox');
//     notifyListeners();
//   }
//
//   // Add a new note
//   Future<void> addNote(String content) async {
//     if (content.isNotEmpty) {
//       final note = Note(content: content);
//       await _notesBox.add(note);
//       notifyListeners();
//     }
//   }
//
//   // Update a note
//   Future<void> updateNoteAt(int index, String newContent) async {
//     if (newContent.isNotEmpty) {
//       final note = _notesBox.getAt(index);
//       if (note != null) {
//         note.content = newContent;
//         await note.save();
//         notifyListeners();
//       }
//     }
//   }
//
//   // Delete a note
//   Future<void> deleteNoteAt(int index) async {
//     await _notesBox.deleteAt(index);
//     notifyListeners();
//   }
//
//   // Clear all notes
//   Future<void> clearNotes() async {
//     await _notesBox.clear();
//     notifyListeners();
//   }
// }
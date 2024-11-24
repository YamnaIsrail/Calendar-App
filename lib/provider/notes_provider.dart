import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../hive/notes_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../hive/notes_model.dart';

class NoteProvider with ChangeNotifier {
  late Box<Note> _notesBox;

  // A list to pair notes with their creation dates
  List<NoteWithDate> get notesWithDates {
    return _notesBox.keys.map((key) {
      final note = _notesBox.get(key);
      // Use the key (or a mock timestamp) as the date
      return NoteWithDate(
        note: note!,
        date: DateTime.fromMillisecondsSinceEpoch(key as int),
      );
    }).toList();
  }

  // Initialize the provider
  Future<void> initialize() async {
    _notesBox = Hive.box<Note>('notesBox');
    notifyListeners();
  }

  // Add a new note with the current date
  Future<void> addNote(String content) async {
    if (content.isNotEmpty) {
      final note = Note(content: content);
      final timestamp = DateTime.now().millisecondsSinceEpoch; // Use current timestamp
      await _notesBox.put(timestamp, note);
      notifyListeners();
    }
  }

  // Update a note
  Future<void> updateNoteAt(int index, String newContent) async {
    if (newContent.isNotEmpty) {
      final note = _notesBox.getAt(index);
      if (note != null) {
        note.content = newContent;
        await note.save();
        notifyListeners();
      }
    }
  }

  // Delete a note
  Future<void> deleteNoteAt(int index) async {
    await _notesBox.deleteAt(index);
    notifyListeners();
  }

  // Clear all notes
  Future<void> clearNotes() async {
    await _notesBox.clear();
    notifyListeners();
  }
}

// Model to pair notes with dates
class NoteWithDate {
  final Note note;
  final DateTime date;
  String get content => note.content; // Access the content directly from the note

  NoteWithDate({required this.note, required this.date});
}

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
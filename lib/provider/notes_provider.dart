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
  late Box<Note> _notesBox;
  bool _isInitialized = false; // Flag to ensure initialization happens only once

  Future<void> initialize() async {
    if (_isInitialized) return; // Skip if already initialized
    _isInitialized = true; // Set the flag to true after initialization starts

    try {
      _notesBox = await Hive.openBox<Note>('notesBox'); // Open Hive box
      notesWithDates = _notesBox.values
          .map((note) => NoteWithDate(content: note.content, date: DateTime.now()))
          .toList();
    } catch (e) {
      print("Error initializing Hive: $e"); // Log the error
    }

    notifyListeners(); // Notify listeners that initialization is complete
  }

  void addNote(String content) {
    final newNote = NoteWithDate(content: content, date: DateTime.now());
    final note = Note(content: content);

    _notesBox.add(note);
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

  List<NoteWithDate> getNotes() {
    return List.from(notesWithDates); // Return a copy of the list to prevent external modification
  }

}

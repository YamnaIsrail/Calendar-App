import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../hive/notes_model.dart';

class NoteProvider with ChangeNotifier {
  late Box<Note> _notesBox;

  List<Note> get notes => _notesBox.values.toList();

  // Initialize the provider
  Future<void> initialize() async {
    _notesBox = await Hive.openBox<Note>('notesBox');
    notifyListeners();
  }

  // Add a new note
  Future<void> addNote(String title, String content) async {
    if (content.isNotEmpty && title.isNotEmpty) {
      final note = Note(
        title: title,
        content: content,
        date: DateTime.now(),
      );
      await _notesBox.add(note);
      notifyListeners();
    } else {
      // You could also show an error message to the user here
      print('Title or content cannot be empty.');
    }
  }

  // Update a note
  Future<void> updateNoteAt(int index, {String? newContent, String? newTitle, DateTime? newDate}) async {
    final note = _notesBox.getAt(index);
    if (note != null) {
      note.updateContent(newContent: newContent, newTitle: newTitle, newDate: newDate);
      await _notesBox.putAt(index, note); // Save the updated note
      notifyListeners();
    } else {
      // Handle case where the note does not exist
      print('Note not found.');
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

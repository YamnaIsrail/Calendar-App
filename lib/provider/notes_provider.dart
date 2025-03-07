import 'package:calender_app/hive/timeline_entry.dart';
import 'package:calender_app/screens/flow2/detail%20page/analysis/timeline/time_line_providers.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
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
      // print("Error initializing Hive: $e"); // Log the error
    }

    notifyListeners(); // Notify listeners that initialization is complete
  }

  void addNote(BuildContext context,String content) {
    final newNote = NoteWithDate(content: content, date: DateTime.now());
    final note = Note(content: content);

    _notesBox.add(note);
    notesWithDates.add(newNote);
    // Add into the timeline system
    final noteEntry = TimelineEntry(
      id: DateTime.now().millisecondsSinceEpoch,
      type: 'Note',
      details: {'Noted': content},
    );

    // Correctly access the provider via context
    final timelineProvider = Provider.of<TimelineProvider>(context, listen: false);
    timelineProvider.addEntry(noteEntry,context);

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

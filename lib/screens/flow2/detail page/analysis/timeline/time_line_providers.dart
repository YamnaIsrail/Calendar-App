
import 'package:calender_app/hive/timeline_entry.dart';
import 'package:calender_app/provider/moods_symptoms_provider.dart';
import 'package:calender_app/provider/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
class TimelinexProvider with ChangeNotifier {
  List<TimelineEntry> _entries = [];

  // References to other providers
  late NoteProvider notesProvider;
  late SymptomsProvider symptomsProvider;
  late MoodsProvider moodsProvider;

  List<TimelineEntry> get entries => _entries;

  /// Call this to inject dependencies and sync data
  void initialize({
    required NoteProvider notesProvider,
    required SymptomsProvider symptomsProvider,
    required MoodsProvider moodsProvider,
  }) {
    this.notesProvider = notesProvider;
    this.symptomsProvider = symptomsProvider;
    this.moodsProvider = moodsProvider;

    _loadCombinedEntries();
  }

  /// Dynamically load data from NotesProvider, SymptomsProvider, and MoodsProvider
  void _loadCombinedEntries() {
    _entries.clear();

    // Add notes to entries
    _entries.addAll(
      notesProvider.notesWithDates.map(
            (note) => TimelineEntry(
          id: DateTime.now().millisecondsSinceEpoch,
          type: 'note',
          details: {'content': note.content},
        ),
      ),
    );

    // Add symptoms to entries
    _entries.addAll(
      symptomsProvider.recentSymptoms.map(
            (symptom) => TimelineEntry(
          id: DateTime.now().millisecondsSinceEpoch,
          type: 'symptom',
          details: {'label': symptom['label'], 'iconPath': symptom['iconPath']},
        ),
      ),
    );

    // Add moods to entries
    _entries.addAll(
      moodsProvider.recentMoods.map(
            (mood) => TimelineEntry(
          id: DateTime.now().millisecondsSinceEpoch,
          type: 'mood',
          details: {'label': mood['label'], 'iconPath': mood['iconPath']},
        ),
      ),
    );

    notifyListeners();
  }

  /// Add a new entry safely
  void addEntry(TimelineEntry entry) {
    _entries.add(entry);
    notifyListeners();
  }

  /// Method to dynamically rebuild entries after providers are updated
  void refreshEntries() {
    _loadCombinedEntries();
  }
}
class TimelineProvider extends ChangeNotifier {
  List<TimelineEntry> _entries = [];
  late Box<TimelineEntry> _timelineBox;

  Future<void> init() async {
    // Open or create the Hive box for timeline entries
    _timelineBox = await Hive.openBox<TimelineEntry>('timeline');
    _entries = _timelineBox.values.toList();
    notifyListeners();
  }

  List<TimelineEntry> get entries => List.unmodifiable(_entries);

  Future<void> addEntry(TimelineEntry entry) async {
    _timelineBox = await Hive.openBox<TimelineEntry>('timeline');
    _entries.add(entry);
    _timelineBox.add(entry); // Save to Hive
    notifyListeners();
  }

  void deleteEntry(int id) {
    final index = _entries.indexWhere((entry) => entry.id == id);
    if (index != -1) {
      _timelineBox.deleteAt(index);
      _entries.removeAt(index);
      notifyListeners();
    }
  }
}




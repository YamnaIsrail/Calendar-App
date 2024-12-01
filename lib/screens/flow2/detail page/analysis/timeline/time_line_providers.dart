
import 'package:calender_app/notifications/notification_storage.dart';
import 'package:calender_app/provider/moods_symptoms_provider.dart';
import 'package:calender_app/screens/flow2/detail%20page/analysis/timeline_dynamic.dart';
import 'package:flutter/material.dart';

import '../../../../../provider/notes_provider.dart';
import 'time_line_entry.dart';

class TimelineProvider extends ChangeNotifier {
  List<TimelineEntry> timelineEntries = [];

  final NoteProvider noteProvider;
  final SymptomsProvider symptomsProvider;
  final MoodsProvider moodsProvider;

  TimelineProvider({
    required this.noteProvider,
    required this.symptomsProvider,
    required this.moodsProvider,
  });

  Future<void> initialize() async {
    // Fetch notes from the NoteProvider
    final notes = noteProvider.notesWithDates;
    // Fetch recent symptoms and moods
    final symptoms = symptomsProvider.recentSymptoms;
    final moods = moodsProvider.recentMoods;

    // Fetch notifications from NotificationStorage
    final notifications = NotificationStorage.getNotifications();

    // Combine all the data into timeline entries
    timelineEntries = [];

    // Add notes to the timeline
    for (var note in notes) {
      timelineEntries.add(TimelineEntry(
        title: 'Note',
        description: note.content,
        date: note.date,
      ));
    }

    // Add recent moods to the timeline
    for (var mood in moods) {
      timelineEntries.add(TimelineEntry(
        title: 'Mood',
        description: mood['label']!,
        date: DateTime.now(),
        mood: mood['label'],
      ));
    }

    // Add recent symptoms to the timeline
    for (var symptom in symptoms) {
      timelineEntries.add(TimelineEntry(
        title: 'Symptom',
        description: symptom['label']!,
        date: DateTime.now(),
        symptom: symptom['label'],
      ));
    }

    // Add notifications to the timeline
    for (var notification in notifications) {
      timelineEntries.add(TimelineEntry(
        title: notification.title,
        description: notification.body, date:  notification.scheduleTime,
      ));
    }

    // Sort the timeline entries by date
    timelineEntries.sort((a, b) => b.date.compareTo(a.date));

    notifyListeners();
  }
}

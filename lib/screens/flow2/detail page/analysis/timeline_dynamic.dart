import 'package:calender_app/provider/moods_symptoms_provider.dart';
import 'package:calender_app/provider/notes_provider.dart';
import 'package:calender_app/screens/flow2/detail%20page/analysis/timeline/time_line_entry.dart';
import 'package:calender_app/screens/flow2/detail%20page/analysis/timeline/time_line_providers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TimelinePage extends StatefulWidget {
  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  late TimelineProvider timelineProvider;

  @override
  void initState() {
    super.initState();
    timelineProvider = TimelineProvider(
      noteProvider: NoteProvider(),
      symptomsProvider: SymptomsProvider(),
      moodsProvider: MoodsProvider(),
    );
    timelineProvider.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timeline'),
      ),
      body: Consumer<TimelineProvider>(
        builder: (context, timeline, child) {
          return ListView.builder(
            itemCount: timeline.timelineEntries.length,
            itemBuilder: (context, index) {
              final entry = timeline.timelineEntries[index];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ListTile(
                  title: Text(entry.title),
                  subtitle: _buildSubtitle(entry),
                  trailing: Text(
                    DateFormat('yyyy-MM-dd HH:mm').format(entry.date),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSubtitle(TimelineEntry entry) {
    // Depending on the entry type (Note, Symptom, Mood, etc.), show different placeholders
    if (entry.type == 'Note') {
      return Text(entry.content ?? "Your notes will appear here.");
    } else if (entry.type == 'Symptom') {
      return Text(entry.content ?? "Your symptoms will appear here.");
    } else if (entry.type == 'Mood') {
      return Text(entry.content ?? "Your moods will appear here.");
    } else if (entry.type == 'Notification') {
      return Text(entry.content ?? "Your notifications will appear here.");
    } else {
      return Text("Unknown entry type.");
    }
  }
}

class TimelineProvider with ChangeNotifier {
  final NoteProvider noteProvider;
  final SymptomsProvider symptomsProvider;
  final MoodsProvider moodsProvider;

  List<TimelineEntry> timelineEntries = [];

  TimelineProvider({
    required this.noteProvider,
    required this.symptomsProvider,
    required this.moodsProvider,
  });

  Future<void> initialize() async {
    // Fetch and populate entries from providers
    timelineEntries.addAll((await noteProvider.getNotes()) as Iterable<TimelineEntry>);
    timelineEntries.addAll((await symptomsProvider.recentSymptoms) as Iterable<TimelineEntry>);
    timelineEntries.addAll((await moodsProvider.recentMoods) as Iterable<TimelineEntry>);
    // Sort or filter entries as needed
    timelineEntries.sort((a, b) => b.date.compareTo(a.date));  // Example: Sort by date
    notifyListeners();
  }
}

// class TimelineEntry {
//   final String title;
//   final String? content;
//   final DateTime date;
//   final String type; // Note, Symptom, Mood, Notification
//
//   TimelineEntry({
//     required this.title,
//     this.content,
//     required this.date,
//     required this.type,
//   });
// }

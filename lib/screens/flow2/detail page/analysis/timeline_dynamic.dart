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
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final timelineProvider = Provider.of<TimelineProvider>(context, listen: false);
      await timelineProvider.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timeline'),
      ),
      body: Consumer<TimelineProvider>(builder: (context, timelineProvider, child) {
        // If data is empty or not loaded, show a placeholder
        if (timelineProvider.timelineEntries.isEmpty) {
          return Center(child: Text('Your timeline will appear here.'));
        }

        return ListView.builder(
          itemCount: timelineProvider.timelineEntries.length,
          itemBuilder: (context, index) {
            final entry = timelineProvider.timelineEntries[index];

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
      }),
    );
  }

  Widget _buildSubtitle(TimelineEntry entry) {
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

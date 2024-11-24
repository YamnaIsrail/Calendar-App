import 'package:calender_app/provider/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calender_app/provider/cycle_provider.dart';
class TimelineEvent {
  final DateTime date;
  final String type; // e.g., "Mood", "Symptom", "Note", "Notification"
  final String content; // Description of the event

  TimelineEvent({
    required this.date,
    required this.type,
    required this.content,
  });
}

class TimeLineD extends StatelessWidget {
  const TimeLineD({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<CycleProvider>(context);
    final noteProvider = Provider.of<NoteProvider>(context);

    // Collect all events and group by date
    final Map<DateTime, List<TimelineEvent>> groupedEvents = _groupEventsByDate(
      cycleProvider: cycleProvider,
      noteProvider: noteProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Timeline"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE8EAF6), Color(0xFFF3E5F5)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: groupedEvents.keys.length,
        itemBuilder: (context, index) {
          final date = groupedEvents.keys.elementAt(index);
          final events = groupedEvents[date]!;

          return _buildDateCard(date, events);
        },
      ),
    );
  }

  // Group events by date
  Map<DateTime, List<TimelineEvent>> _groupEventsByDate({
    required CycleProvider cycleProvider,
    required NoteProvider noteProvider,
  }) {
    final Map<DateTime, List<TimelineEvent>> groupedEvents = {};

    // Collect moods and symptoms from CycleProvider
    for (var symptom in cycleProvider.symptoms) {
      final event = TimelineEvent(
        date: DateTime.now(), // Replace with the correct date for the symptom
        type: "Symptom",
        content: symptom,
      );
      groupedEvents.putIfAbsent(event.date, () => []).add(event);
    }

    // Collect notes from NoteProvider
    for (var note in noteProvider.notesWithDates) {
      final event = TimelineEvent(
        date: note.date, // Use `note.date` for the event date
        type: "Note",    // Set the type as "Note"
        content: note.content, // Fetch `content` directly
      );
      groupedEvents.putIfAbsent(event.date, () => []).add(event);
    }

// Sort grouped events by date (optional)
    final sortedEvents = groupedEvents.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Sort dates
    return Map.fromEntries(groupedEvents.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key)));
  }

  // Build a card for a specific date
  Widget _buildDateCard(DateTime date, List<TimelineEvent> events) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Header
            Text(
              "${date.day}-${date.month}-${date.year}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            // Event Details
            ...events.map((event) {
              return ListTile(
                leading: _getEventIcon(event.type),
                title: Text(event.type),
                subtitle: Text(event.content),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // Get an icon based on event type
  Icon _getEventIcon(String type) {
    switch (type) {
      case "Mood":
        return const Icon(Icons.mood, color: Colors.blue);
      case "Symptom":
        return const Icon(Icons.healing, color: Colors.red);
      case "Note":
        return const Icon(Icons.note, color: Colors.green);
      case "Notification":
        return const Icon(Icons.notifications, color: Colors.orange);
      default:
        return const Icon(Icons.event, color: Colors.grey);
    }
  }
}

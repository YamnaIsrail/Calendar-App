import 'package:calender_app/screens/flow2/detail%20page/analysis/timeline/time_line_entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../hive/timeline_entry.dart';
import 'timeline/time_line_providers.dart';

class TimeLineCheck extends StatelessWidget {
  const TimeLineCheck({super.key});

  @override
  Widget build(BuildContext context) {
    final timelineProvider = Provider.of<TimelineProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Timeline"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE8EAF6), Color(0xFFF3E5F5)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: timelineProvider.entries.isEmpty
          ? Center(child: CircularProgressIndicator()) // Wait until data is initialized
          : SingleChildScrollView(
        child: Column(
          children: timelineProvider.groupedEntries.entries.map((entry) {
            return buildCard(context, entry.key, entry.value);
          }).toList(),
        ),
      ),
    );
  }

  Widget buildCard(BuildContext context, String date, List<TimelineEntry> entries) {
    final notifications = entries.where((e) => e.details['notification'] != null).toList();
    final moods = entries.where((e) => e.details['mood'] != null).toList();
    final symptoms = entries.where((e) => e.details['symptom'] != null).toList();

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Divider(),
            if (notifications.isNotEmpty)
              buildListView(
                "Notifications",
                notifications.map((e) => e.details['notification'] as String).toList(),
              ),
            if (moods.isNotEmpty)
              buildListView(
                "Moods",
                moods.map((e) => e.details['mood'] as String).toList(),
              ),
            if (symptoms.isNotEmpty)
              buildListView(
                "Symptoms",
                symptoms.map((e) => e.details['symptom'] as String).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildListView(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        for (var item in items)
          Text(
            item,
            style: TextStyle(fontSize: 14),
          ),
        SizedBox(height: 8),
      ],
    );
  }
}

import 'package:calender_app/hive/timeline_entry.dart';
import 'package:calender_app/screens/flow2/detail%20page/analysis/timeline/time_line_entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../firebase/analytics/analytics_service.dart';
import 'timeline/time_line_providers.dart';

class TimelinePage extends StatefulWidget {
  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now(); // Record the entry time
    AnalyticsService.logScreenView("TimelinePage");
  }

  @override
  void dispose() {
    if (_startTime != null) {
      int duration = DateTime.now().difference(_startTime!).inSeconds;
      AnalyticsService.logScreenTime("TimelinePage", duration);
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final timelineProvider = Provider.of<TimelineProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Timeline'),
      ),
      body: timelineProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : timelineProvider.entries.isEmpty
          ? Center(child: Text('No timeline entries available.'))
          : _buildTimeline(timelineProvider, timelineProvider.entries),
     );
  }

  Widget _buildTimeline(TimelineProvider timelineProvider, List<TimelineEntry> entries) {
    Map<DateTime, List<TimelineEntry>> groupedEntries = {};
    for (var entry in entries) {
      final date = DateTime(entry.date.year, entry.date.month, entry.date.day);
      if (groupedEntries[date] == null) {
        groupedEntries[date] = [];
      }
      groupedEntries[date]!.add(entry);
    }

    // Sort dates in descending order
    var sortedDates = groupedEntries.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final entriesForDay = groupedEntries[date]!;
        final day = date.day.toString();
        final month = _getMonthAbbreviation(date.month);
        final weekDay = _getWeekdayAbbreviation(date.weekday);

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(

              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.pink[100],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        weekDay,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        day,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        month,
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      for (var i = 0; i < entriesForDay.length; i++)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (i > 0)
                              Divider(
                                color: Colors.grey,
                                height: 5,
                                thickness: 1,
                                indent: 0,
                                endIndent: 0,
                              ),

                            _buildEntry(context,timelineProvider, entriesForDay[i]),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEntry(BuildContext context,TimelineProvider timelineProvider, TimelineEntry entry) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.type,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              // Wrap the text in a Container with constraints and enable text wrapping
              Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7), // Adjust max width as needed
                child: Text(
                  entry.details
                      .toString()
                      .replaceAll('{', '')
                      .replaceAll('}', '')
                      .replaceAll('You Feel:', '')
                      .replaceAll('You feel:', '')
                      .replaceAll('Noted:', ''),
                  style: TextStyle(fontSize: 14),
                  softWrap: true, // Enable text wrapping
                  overflow: TextOverflow.visible, // Allow text to wrap to the next line
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            // Handle delete action
            timelineProvider.deleteEntry(entry.id);
          },
        ),
      ],
    );
  }

  /// Helper method to get the abbreviated weekday
  String _getWeekdayAbbreviation(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }

  /// Helper method to get the abbreviated month
  String _getMonthAbbreviation(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
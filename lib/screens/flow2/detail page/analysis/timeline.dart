import 'package:calender_app/screens/flow2/detail%20page/analysis/timeline/time_line_entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../hive/timeline_entry.dart';
import 'timeline/time_line_providers.dart';
class TimelinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timelineProvider = Provider.of<TimelineProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Timeline'),
      ),
      body: timelineProvider.entries.isEmpty
          ? Center(child: Text('No timeline entries available.'))
          : ListView.builder(
        itemCount: timelineProvider.entries.length,
        itemBuilder: (context, index) {
          final entry = timelineProvider.entries[index];
          final date = entry.date.toLocal();
          final day = date.day.toString();
          final month = _getMonthAbbreviation(date.month);
          final weekDay = _getWeekdayAbbreviation(date.weekday);

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  // Date Container
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
                          weekDay, // Dynamic weekday
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          day, // Dynamic date
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          month, // Dynamic month
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  // Content Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.type, // Dynamic title
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        SizedBox(height: 4),
                        Text(
                          entry.details.toString().replaceAll('{', '').replaceAll('}', ''),
                        ),
                      ],
                    ),
                  ),
                  // Delete Button
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _confirmDelete(context, timelineProvider, entry.id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Helper method to confirm deletion
  void _confirmDelete(BuildContext context, TimelineProvider provider, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Entry'),
        content: Text('Are you sure you want to delete this entry?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteEntry(id); // Delete the entry
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
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

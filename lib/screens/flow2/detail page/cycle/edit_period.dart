import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package for DateFormat
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart'; // Import table_calendar package

class CalendarViewPage extends StatefulWidget {
  @override
  _CalendarViewPageState createState() => _CalendarViewPageState();
}

class _CalendarViewPageState extends State<CalendarViewPage> {
  DateTime? _selectedDay;
  Set<DateTime> _markedPeriodDays = {};

  @override
  Widget build(BuildContext context) {
    final cycleProvider = context.watch<CycleProvider>();

    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text('Edit Periods', style: TextStyle(color: Colors.black)),
          leading: CircleAvatar(
            backgroundColor: Color(0xffFFC4E8),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        body: ListView(
          children: [
            // Calendar to select period days
            Card(
              margin: EdgeInsets.all(10),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: _selectedDay ?? DateTime.now(),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, date, _) {
                    final normalizedDate = DateTime(date.year, date.month, date.day);
                    if (_markedPeriodDays.contains(normalizedDate)) {
                      return _buildCalendarCell(
                        date: date,
                        color: Colors.red[100],
                        textColor: Colors.red,
                      );
                    }
                    return null; // Use default style for unmarked days
                  },
                ),
                calendarStyle: CalendarStyle(
                  defaultTextStyle: TextStyle(color: Colors.black),
                  weekendTextStyle: TextStyle(color: Colors.red),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    final normalizedDate = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
                    if (_markedPeriodDays.contains(normalizedDate)) {
                      _markedPeriodDays.remove(normalizedDate); // Unmark if already marked
                    } else {
                      _markedPeriodDays.add(normalizedDate); // Mark as period day
                    }
                  });
                },
              ),
            ),

            SizedBox(height: 20),

            // Save and Delete Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: CustomButton(
                text: "Save",
                onPressed: () {
                  cycleProvider.updateCycleData(
                    lastPeriodStart: _markedPeriodDays.isNotEmpty
                        ? _markedPeriodDays.first
                        : DateTime.now(),
                    cycleLength: 28,
                    periodLength: _markedPeriodDays.length,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Period days updated!"),
                  ));
                },
                backgroundColor: primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomButton(
                text: "Clear",
                textColor: Colors.black,
                onPressed: () {
                  setState(() {
                    _markedPeriodDays.clear(); // Clear all markings
                  });
                },
                backgroundColor: secondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build styled calendar cells
  Widget _buildCalendarCell({required DateTime date, Color? color, Color? textColor, Border? border}) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color ?? Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: border ?? Border.all(color: Colors.transparent),
        ),
        child: Center(
          child: Text(
            date.day.toString(),
            style: TextStyle(color: textColor ?? Colors.black),
          ),
        ),
      ),
    );
  }
}

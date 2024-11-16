import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package for DateFormat
import 'package:table_calendar/table_calendar.dart'; // Import table_calendar package

class CalendarViewPage extends StatefulWidget {
  @override
  _CalendarViewPageState createState() => _CalendarViewPageState();
}

class _CalendarViewPageState extends State<CalendarViewPage> {
  DateTime? _selectedDay;
  DateTime? _startDate;
  int? _periodDuration;

  // To store selected period info
  String? _formattedStartDate;
  String? _formattedEndDate;

  // Initialize the calendar format
  late final CalendarFormat _calendarFormat;

  // A set to keep track of marked days (start and end of period)
  final Set<DateTime> _markedDates = {};

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
  }

  // Method to mark the period dates
  void _markPeriodDates() {
    if (_startDate != null && _periodDuration != null) {
      // Clear any previous markings
      _markedDates.clear();

      // Mark start date
      _markedDates.add(_startDate!);

      // Mark the subsequent period days
      for (int i = 1; i < _periodDuration!; i++) {
        _markedDates.add(_startDate!.add(Duration(days: i)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return  bgContainer(
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
          // Table Calendar for selecting dates
          Card(
            margin: EdgeInsets.all(10),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2025, 12, 31),
              focusedDay: _selectedDay ?? DateTime.now(),
              calendarFormat: _calendarFormat,
              startingDayOfWeek: StartingDayOfWeek.monday,
              selectedDayPredicate: (day) {
                // Highlight selected day
                return _selectedDay != null && isSameDay(_selectedDay!, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _startDate = selectedDay;
                  _markPeriodDates(); // Update the marked dates
                });
              },
              // Decorating the days with circles for the period days
              eventLoader: (day) {
                if (_markedDates.contains(day)) {
                  return [''];
                }
                return [];
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (_markedDates.contains(date)) {
                    // Custom marker (circle) for marked dates
                    return Positioned(
                      bottom: 1,
                      right: 1,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
          ),

          SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: CustomButton(
                text: "Save", onPressed: () {}, backgroundColor: primaryColor),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomButton(
                text: "Delete",
                textColor: Colors.black,
                onPressed: () {},
                backgroundColor: secondaryColor),
          )
        ],
      ),
        ));
  }
}

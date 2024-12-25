import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package for DateFormat
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart'; // Import table_calendar package

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}
class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now(); // Track focused day

  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<CycleProvider>(context);


    void _onDateClicked(BuildContext context, DateTime clickedDate) {
      final periodProvider = Provider.of<CycleProvider>(context, listen: false);
      bool dateFound = false;

      // Check existing periods
      for (var period in periodProvider.pastPeriods) {
        final startDate = DateTime.tryParse(period['startDate']!);
        final endDate = DateTime.tryParse(period['endDate']!);

        // Ensure that startDate and endDate are valid
        if (startDate != null && endDate != null) {
          // If the clicked date is within the existing period
          if (!clickedDate.isBefore(startDate) && !clickedDate.isAfter(endDate)) {
            dateFound = true;

            // If the clicked date is at the start or end of the period
            if (clickedDate.isAtSameMomentAs(startDate)) {
              periodProvider.removePastPeriod(startDate.toIso8601String());
            } else if (clickedDate.isAtSameMomentAs(endDate)) {
              periodProvider.removePastPeriod(startDate.toIso8601String());
            } else {
              // Update the period end date
              DateTime newEndDate = clickedDate;

              // Update period length
              int periodLength = newEndDate.difference(startDate).inDays + 1; // +1 to include both start and end date
              periodProvider.updatePeriodLength(periodLength);

              // Remove the old period and add the updated period
              //periodProvider.removePastPeriod(startDate.toIso8601String());
              periodProvider.addPastPeriod(startDate, newEndDate);
            }
            break;
          } else if (clickedDate.isAfter(endDate)) {
            // If the clicked date is after the current period, check the difference
            if (clickedDate.difference(endDate).inDays <= 5) {
              // Extend the existing period
              DateTime newEndDate = clickedDate.subtract(Duration(days: 1));

              int periodLength = newEndDate.difference(startDate).inDays + 1;
              periodProvider.updatePeriodLength(periodLength);

              periodProvider.addPastPeriod(startDate, newEndDate);
              dateFound = true;
              break;
            }
          }
        }
      }

      // If no matching period is found, treat it as a new period
      if (!dateFound) {
        DateTime newEndDate = clickedDate.add(Duration(days: periodProvider.periodLength - 1));

        // Update the period length in the provider
        periodProvider.updatePeriodLength(periodProvider.periodLength);
        periodProvider.addPastPeriod(clickedDate, newEndDate);
      }

      // Update the focused day to the clicked date
      setState(() {
        _focusedDay = clickedDate;
      });
    }


    void _onxDateClicked(BuildContext context, DateTime clickedDate) {
      final periodProvider = Provider.of<CycleProvider>(context, listen: false);
      bool dateFound = false;

      // Calculate the period length (number of days between start and clicked date)
      for (var period in periodProvider.pastPeriods) {
        final startDate = DateTime.tryParse(period['startDate']!);
        final endDate = DateTime.tryParse(period['endDate']!);

        // Ensure that startDate and endDate are valid
        if (startDate != null && endDate != null) {
          // Ensure the clicked date is within the period, inclusive of start and end dates
          if (!clickedDate.isBefore(startDate) && !clickedDate.isAfter(endDate)) {
            dateFound = true;

            // If the clicked date is at the start or end of the period
            if (clickedDate.isAtSameMomentAs(startDate)) {
              periodProvider.removePastPeriod(startDate.toIso8601String());
            } else if (clickedDate.isAtSameMomentAs(endDate)) {
              periodProvider.removePastPeriod(startDate.toIso8601String());
            } else {
              // Calculate the updated period end date
              DateTime newEndDate = clickedDate.subtract(Duration(days: 1));

              // Update period length based on the selected range (inclusive of both dates)
              int periodLength = newEndDate.difference(startDate).inDays + 1; // +1 to include both start and end date

              // Update the period length in the provider
              periodProvider.updatePeriodLength(periodLength);

              // Remove the old period and add the updated period
              periodProvider.removePastPeriod(startDate.toIso8601String());
              periodProvider.addPastPeriod(startDate, newEndDate);
            }
            break;
          } else if (clickedDate.isAfter(endDate)) {
            // If the clicked date is after the current period, extend the period
            DateTime newEndDate = clickedDate;

            // Update period length based on the selected range (inclusive of both dates)
            int periodLength = newEndDate.difference(startDate).inDays + 1; // +1 to include both start and end date

            // Update the period length in the provider
            periodProvider.updatePeriodLength(periodLength);

            // Remove the old period and add the new extended period
            periodProvider.removePastPeriod(startDate.toIso8601String());
            periodProvider.addPastPeriod(startDate, newEndDate);
            dateFound = true;
            break;
          }
        }
      }

      // If no matching period is found, add a new period
      if (!dateFound) {
        DateTime newEndDate = clickedDate.add(Duration(days: periodProvider.periodLength - 1));

        // Update the period length in the provider
        periodProvider.updatePeriodLength(periodProvider.periodLength);

        periodProvider.addPastPeriod(clickedDate, newEndDate);
      }

      // Update the focused day to the clicked date
      setState(() {
        _focusedDay = clickedDate;
      });
    }

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
        body: Container(
          height: 500,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay, // Set the focused day to the state variable
            onDaySelected: (selectedDay, focusedDay) {
              _onDateClicked(context, selectedDay);
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, date, _) {
                for (var period in cycleProvider.pastPeriods) {
                  // Ensure that startDate and endDate are not null before parsing
                  if (period['startDate'] != null && period['endDate'] != null) {
                    final startDate = DateTime.tryParse(period['startDate']!);
                    final endDate = DateTime.tryParse(period['endDate']!);

                    // Check if the dates were parsed successfully
                    if (startDate != null && endDate != null) {
                      // Adjust comparison to ensure both start and end dates are inclusive
                      if (!date.isBefore(startDate) && !date.isAfter(endDate)) {
                        return _buildCalendarCell(date: date, color: Colors.red);
                      }
                    }
                  }
                }

                return null;
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarCell({
    required DateTime date,
    Color? color,
    Border? border,
  }) {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color,
        border: border,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          date.day.toString(),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}



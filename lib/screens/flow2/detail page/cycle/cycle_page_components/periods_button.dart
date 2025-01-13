
import 'package:calender_app/hive/cycle_model.dart';
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/provider/date_day_format.dart';
import 'package:calender_app/provider/preg_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';


//Corrected version
class PeriodButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: () => _selectStartDate(context),
          icon: Icon(Icons.play_arrow, color: Colors.pink),
          label: Text("Start", style: TextStyle(color: Colors.pink)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink[100],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _selectEndDate(context),
          icon: Icon(Icons.stop, color: Colors.blue),
          label: Text("End", style: TextStyle(color: Colors.blueAccent)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFA2BAF6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _removePeriod(context),
          icon: Icon(Icons.delete, color: Colors.red),
          label: Text("Remove", style: TextStyle(color: Colors.red)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[100],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ],
    );
  }

  // Method to handle selecting the start date
  void _selectStartDate(BuildContext context) async {
    final provider = Provider.of<CycleProvider>(context, listen: false);

    final DateTime? pickedStartDate = await _pickDate(context, isStart: true);

    if (pickedStartDate != null) {
      provider.updateLastPeriodStart(pickedStartDate);
      print("Period start updated: $pickedStartDate");
    }
  }

  void _selectEndDate(BuildContext context) async {
    final provider = Provider.of<CycleProvider>(context, listen: false);

    final DateTime? pickedEndDate = await _pickDate(context, isStart: false);

    if (pickedEndDate != null) {
      final startDate = provider.getLastPeriodStartForEnd();
      if (startDate != null) {
        if (pickedEndDate.isAfter(startDate) || pickedEndDate.isAtSameMomentAs(startDate)) {
          provider.addPastPeriod(startDate, pickedEndDate);

          final periodLength = pickedEndDate.difference(startDate).inDays+1;
          provider.updatePeriodLength(periodLength); // Update the period length
          print("Period updated: Start: $startDate, End: $pickedEndDate, Period Length: $periodLength days");
        } else {
          _showSnackbar(context, "End date cannot be before start date");
        }
      } else {
        _showSnackbar(context, "Please select a valid start date first");
      }
    }
  }


  Future<DateTime?> _pickDate(BuildContext context, {required bool isStart}) async {
    final provider = Provider.of<CycleProvider>(context, listen: false);

    DateTime? initialDate;

    if (isStart) {
      // Allow the user to select the start date independently
      initialDate = DateTime.now(); // Start date can be any date
    } else {
      // For end date, check if a start date is already selected
      final startDate = provider.getLastPeriodStartForEnd();
      if (startDate == null) {
        // Show a Snackbar if no start date has been selected
        _showSnackbar(context, "Please select a valid start date first.");
        return null; // Return null if no start date is selected
      }
      initialDate = startDate; // For the end date, set the initial date as the start date
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    return pickedDate;
  }

  // Method to remove a period
  void _removePeriod(BuildContext context) async {
    final provider = Provider.of<CycleProvider>(context, listen: false);

    if (provider.pastPeriods.length > 1) {
      final startDate = await _selectPeriodToRemove(context, provider);

      if (startDate != null) {
        // Remove the selected period
        provider.removePastPeriod(startDate.toIso8601String());
        print("Period removed: $startDate");
      }
    } else {
      _showSnackbar(context, "You cannot delete all records. At least one period is required.");
    }
  }

  // Method to show the dialog for selecting a period to remove
  Future<DateTime?> _selectPeriodToRemove(BuildContext context, CycleProvider provider) async {
    final periodToRemove = await showDialog<DateTime>(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Select Period to Remove"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: provider.pastPeriods.map((period) {
              DateTime startDate = DateTime.parse(period['startDate']!);
              DateTime endDate = DateTime.parse(period['endDate']!);

              return ListTile(
                title: Text(
                  "Start: ${DateFormat(context.watch<SettingsModel>().dateFormat).format(startDate)}",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                trailing: Text(
                  "End: ${DateFormat(context.watch<SettingsModel>().dateFormat).format(endDate)}",
                ),
                onTap: () {
                  Navigator.pop(context, startDate);  // Return the selected start date
                },
              );
            }).toList(),
          ),
        ),
      );
    });

    return periodToRemove;
  }

  // Helper method to show snackbars
  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}



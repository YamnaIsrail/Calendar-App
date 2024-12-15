
import 'package:calender_app/hive/cycle_model.dart';
import 'package:calender_app/provider/cycle_provider.dart';
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

          final periodLength = pickedEndDate.difference(startDate).inDays + 1;
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

  // void _selectEndDate(BuildContext context) async {
  //   final provider = Provider.of<CycleProvider>(context, listen: false);
  //
  //   final DateTime? pickedEndDate = await _pickDate(context, isStart: false);
  //
  //   if (pickedEndDate != null) {
  //     final startDate = provider.getLastPeriodStartForEnd();
  //     if (startDate != null) {
  //       if (pickedEndDate.isAfter(startDate) || pickedEndDate.isAtSameMomentAs(startDate)) {
  //        provider.addPastPeriod(startDate, pickedEndDate);
  //
  //         final periodLength = pickedEndDate.difference(startDate).inDays+1;
  //         provider.updatePeriodLength(periodLength); // Update the period length
  //         print("Period updated: Start: $startDate, End: $pickedEndDate, Period Length: $periodLength days");
  //       } else {
  //         _showSnackbar(context, "End date cannot be before start date");
  //       }
  //     } else {
  //       _showSnackbar(context, "Please select a valid start date first");
  //     }
  //   }
  // }

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
    final startDate = await _selectPeriodToRemove(context, provider);
    if (startDate != null) {
      provider.removePastPeriod(startDate.toIso8601String());
      print("Period removed: $startDate");
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
                title: Text("Start: ${DateFormat('yyyy-MM-dd').format(startDate)}"),
                trailing: Text("End: ${DateFormat('yyyy-MM-dd').format(endDate)}"),
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


class CustomDatePicker extends StatelessWidget {
  final DateTime? initialDate;
  final Function(DateTime) onDateSelected;

  CustomDatePicker({
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await _showStyledDatePicker(context);
        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          initialDate != null
              ? DateFormat.yMd().format(initialDate!)
              : 'Select Date',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Future<DateTime?> _showStyledDatePicker(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime.utc(2020, 1, 1),
      lastDate: DateTime.utc(2025, 12, 31),
      builder: (BuildContext context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            hintColor: Colors.blue,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            // Customize the date picker styles
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // Color of the selected date text
              ),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      // Apply custom date styling logic
      _highlightSpecialDates(context, selectedDate);
      return selectedDate;
    }
    return null;
  }

  // Custom logic to highlight specific dates (e.g., cycle, fertile, etc.)
  void _highlightSpecialDates(BuildContext context, DateTime selectedDate) {
    // Here, we can add the logic to highlight the specific dates based on
    // pregnancy, cycle, or predicted days similar to your TableCalendar setup.
    // This can involve adding custom markers, colors, or decorations.

    final cycleProvider = Provider.of<CycleProvider>(context, listen: false);
    final pregnancyProvider = Provider.of<PregnancyModeProvider>(context, listen: false);

    if (pregnancyProvider.isPregnancyMode) {
      // Pregnancy mode styling
      if (pregnancyProvider.gestationStart != null) {
        final pregnancyStartDays = selectedDate.difference(pregnancyProvider.gestationStart!).inDays;
        if (pregnancyStartDays == 0) {
          // Customize color or styling for pregnancy start date
        }
      }
    } else {
      // Cycle mode styling (past periods, fertile days, predicted days)
      for (var period in cycleProvider.pastPeriods) {
        final startDate = DateTime.parse(period['startDate']!);
        final endDate = DateTime.parse(period['endDate']!);

        if (selectedDate.isAfter(startDate.subtract(Duration(days: 1))) &&
            selectedDate.isBefore(endDate.add(Duration(days: 1)))) {
          // Customize styling for dates within the cycle period
        }
      }

      // Additional logic for other cycle days like periodDays, predictedDays, etc.
    }
  }
}

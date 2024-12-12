import 'package:calender_app/hive/cycle_model.dart';
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
// class PeriodButtons extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         ElevatedButton.icon(
//           onPressed: () => _selectDate(context, isStart: true),
//           icon: Icon(Icons.play_arrow, color: Colors.pink),
//           label: Text("Start", style: TextStyle(color: Colors.pink)),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.pink[100],
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           ),
//         ),
//         ElevatedButton.icon(
//           onPressed: () => _selectDate(context, isStart: false),
//           icon: Icon(Icons.stop, color: Colors.blue),
//           label: Text("End", style: TextStyle(color: Colors.blueAccent)),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Color(0xFFA2BAF6),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _selectDate(BuildContext context, {required bool isStart}) async {
//     final provider = Provider.of<CycleProvider>(context, listen: false);
//     final initialDate = isStart ? DateTime.now() : provider.lastPeriodStart;  // Set initialDate to today for the "Start" button
//
//     // Display Date Picker
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//     );
//
//     if (pickedDate != null) {
//       if (isStart) {
//         provider.updateLastPeriodStart(pickedDate);
//         print("Period start updated: $pickedDate");
//       } else {
//         final periodEndDate = pickedDate;
//         final periodLength = periodEndDate.difference(provider.lastPeriodStart).inDays;
//         provider.updatePeriodLength(periodLength);
//         print("Period end updated: $periodEndDate");
//       }
//     }
//   }
// }




//

class PeriodButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: () => _selectDate(context, isStart: true),
          icon: Icon(Icons.play_arrow, color: Colors.pink),
          label: Text("Start", style: TextStyle(color: Colors.pink)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink[100],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _selectDate(context, isStart: false),
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

  void _selectDate(BuildContext context, {required bool isStart}) async {
    final provider = Provider.of<CycleProvider>(context, listen: false);
    final initialDate = isStart ? DateTime.now() : provider.lastPeriodStart ?? DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      if (isStart) {
        final startDateStr = pickedDate.toIso8601String();  // Correct this line to use the selected date
        provider.addPastPeriod(startDateStr);
        provider.updateLastPeriodStart(pickedDate);
        print("Period start updated: $pickedDate");
      } else {
        final periodEndDate = pickedDate;
        final startDateStr = provider.lastPeriodStart!.toIso8601String();
        final endDateStr = periodEndDate.toIso8601String();
        provider.addPastPeriod(startDateStr);
        print("Period added: Start: $startDateStr, End: $endDateStr");
      }
    }
  }

  void _removePeriod(BuildContext context) async {
    final provider = Provider.of<CycleProvider>(context, listen: false);

    // Let user select which period to remove
    final startDateStr = await _selectPeriodToRemove(context, provider);
    if (startDateStr != null) {
      provider.removePastPeriod(startDateStr);
      print("Period removed: $startDateStr");
    }
  }

  // Future<String?> _selectPeriodToRemove(BuildContext context, CycleProvider provider) async {
  //   // This is a simple implementation. You can display a list or use other logic for selection.
  //   final periodToRemove = await showDialog<String>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Select Period to Remove"),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             children: provider.pastPeriods.map((period) {
  //               return ListTile(
  //                 title: Text(period),
  //                 onTap: () {
  //                   Navigator.pop(context, period);  // Return the selected period
  //                 },
  //               );
  //             }).toList(),
  //           ),
  //         )
  //       );
  //     },
  //   );
  //
  //   return periodToRemove;  // Return the selected start date string
  // }

  Future<String?> _selectPeriodToRemove(BuildContext context, CycleProvider provider) async {
    final periodToRemove = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Period to Remove"),
          content: SingleChildScrollView(  // Wrap the Column with SingleChildScrollView for scrolling
            child: Column(
              mainAxisSize: MainAxisSize.min,  // Ensures the Column takes only the necessary height
              children: provider.pastPeriods.map((period) {
                // Assuming period is in ISO 8601 format (e.g., "2024-12-12T00:00:00.000")
                DateTime parsedDate = DateTime.parse(period);
                String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);  // Format the date to "YYYY-MM-DD"

                return ListTile(
                  title: Text(formattedDate),  // Display the formatted date
                  onTap: () {
                    Navigator.pop(context, period);  // Return the selected period
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    return periodToRemove;  // Return the selected start date string
  }

}

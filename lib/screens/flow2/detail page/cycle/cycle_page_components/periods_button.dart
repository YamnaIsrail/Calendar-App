import 'package:calender_app/provider/cycle_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//
// class PeriodButtons extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         ElevatedButton.icon(
//           onPressed: () {},
//           icon: Icon(Icons.play_arrow, color: Colors.pink),
//           label: Text("Start", style: TextStyle(color: Colors.pink)),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.pink[100],
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           ),
//         ),
//         ElevatedButton.icon(
//           onPressed: () {},
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
// }
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
      ],
    );
  }

  void _selectDate(BuildContext context, {required bool isStart}) async {
    final provider = Provider.of<CycleProvider>(context, listen: false);
    final initialDate = isStart ? DateTime.now() : provider.lastPeriodStart;  // Set initialDate to today for the "Start" button

    // Display Date Picker
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      if (isStart) {
        provider.updateLastPeriodStart(pickedDate);
        print("Period start updated: $pickedDate");
      } else {
        final periodEndDate = pickedDate;
        final periodLength = periodEndDate.difference(provider.lastPeriodStart).inDays;
        provider.updatePeriodLength(periodLength);
        print("Period end updated: $periodEndDate");
      }
    }
  }
}

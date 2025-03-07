import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../provider/date_day_format.dart';

// class DateNavigation extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final dayNames = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
//
//     // Watch for the firstDayOfWeek from the SettingsModel
//     final firstDayOfWeek = context.watch<SettingsModel>().firstDayOfWeek;
//
//     // Get current date
//     DateTime now = DateTime.now();
//
//     // Find the current weekday as per Dart's weekday system (1 = Monday, 7 = Sunday)
//     int currentWeekday = now.weekday;
//
//     // Adjust currentWeekday if the first day of the week is Sunday
//     if (firstDayOfWeek == "Sunday" && currentWeekday == 7) {
//       currentWeekday = 0; // Make Sunday behave as 0
//     }
//
//     // Adjust the start of the week based on firstDayOfWeek
//     int firstDayIndex = dayNames.indexOf(firstDayOfWeek.substring(0, 3).toUpperCase());
//
//     // Find the start of the week based on selected first day of the week
//     DateTime startOfWeek = now.subtract(Duration(days: (currentWeekday - firstDayIndex + 7) % 7));
//
//     // Generate week dates starting from the adjusted start of the week
//     List<DateTime> weekDates = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16.0),
//       height: 140,
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: List.generate(7, (index) {
//             // Check if today is the same day as the current iteration
//             bool isSelected = (weekDates[index].day == now.day) &&
//                 (weekDates[index].month == now.month) &&
//                 (weekDates[index].year == now.year);
//
//             return Container(
//               width: 52, // Adjust width for items
//               margin: EdgeInsets.symmetric(horizontal: 4.0),
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               decoration: BoxDecoration(
//                 gradient: isSelected
//                     ? LinearGradient(
//                   colors: [Color(0xFFD6A4F8), Color(0xFF5A5FE3)],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 )
//                     : LinearGradient(
//                   colors: [Color(0xFFE8EAF6), Color(0xFFE6BAEE)],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     spreadRadius: 1,
//                     blurRadius: 4,
//                     offset: Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     dayNames[(index + firstDayIndex) % 7], // Adjust day name based on the first day
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: isSelected ? Colors.white : Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     '${weekDates[index].day}', // Dynamic date
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: isSelected ? Colors.white : Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }

class DateNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dayNames = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];

    // Watch for the firstDayOfWeek from the SettingsModel
    final firstDayOfWeek = context.watch<SettingsModel>().firstDayOfWeek;

    // Get current date
    DateTime now = DateTime.now();

    // Find the current weekday as per Dart's weekday system (1 = Monday, 7 = Sunday)
    int currentWeekday = now.weekday;

    // Adjust currentWeekday if the first day of the week is Sunday
    if (firstDayOfWeek == "Sunday" && currentWeekday == 7) {
      currentWeekday = 0; // Make Sunday behave as 0
    }

    // Adjust the start of the week based on firstDayOfWeek
    int firstDayIndex = dayNames.indexOf(firstDayOfWeek.substring(0, 3).toUpperCase());

    // Find the start of the week based on selected first day of the week
    DateTime startOfWeek = now.subtract(Duration(days: (currentWeekday - firstDayIndex + 7) % 7));

    // Generate week dates starting from the adjusted start of the week
    List<DateTime> weekDates = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));

    LinearGradient containerGradient = LinearGradient(
      colors: [
        Color(0xFFE7C9FF), // Color at 2%
        Color(0xFFD7E7F8), // Color at 88%
      ],
      stops: [0.02, 0.88], // Stops for the colors
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      height: 140,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(7, (index) {
            // Check if today is the same day as the current iteration
            bool isSelected = (weekDates[index].day == now.day) &&
                (weekDates[index].month == now.month) &&
                (weekDates[index].year == now.year);

            return Container(
              width: 52, // Adjust width for items
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: containerGradient, // Use linear gradient for all
                // Use single color for all
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayNames[(index + firstDayIndex) % 7], // Adjust day name based on the first day
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff3c3c6b), // Change text color to white
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4), // Adjust spacing
                  Container(
                    width: 2, // Width of the vertical line
                    height: 20, // Height of the vertical line
                    color: Colors.white, // Color of the line
                  ),
                  const SizedBox(height: 4), // Adjust spacing
                  Text(
                    '${weekDates[index].day}', // Dynamic date
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black, // Change text color to white
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
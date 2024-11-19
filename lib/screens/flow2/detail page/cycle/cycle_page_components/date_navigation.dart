import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date manipulation

class DateNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dayNames = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];

    // Get current date and week
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday % 7)); // Sunday
    List<DateTime> weekDates = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      height: 140,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(dayNames.length, (index) {
            bool isSelected = (weekDates[index].day == now.day);

            return Container(
              width: 52, // Adjust width for items
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                  colors: [
                    Color(0xFFD6A4F8),
                    Color(0xFF5A5FE3),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
                    : LinearGradient(
                  colors: [
                    Color(0xFFE8EAF6),
                    Color(0xFFE6BAEE),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
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
                    dayNames[index],
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${weekDates[index].day}', // Dynamic date
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected ? Colors.white : Colors.black,
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

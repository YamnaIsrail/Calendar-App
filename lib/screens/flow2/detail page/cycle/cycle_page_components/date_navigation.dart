import 'package:flutter/material.dart';

class DateNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dayNames = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
    final dates = [9, 10, 11, 12, 13, 14, 15]; // Example dates

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      height: 140,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(dayNames.length, (index) {
          bool isSelected = (index == 2);

          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
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
                      color: isSelected ? Colors.black : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${dates[index]}',
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

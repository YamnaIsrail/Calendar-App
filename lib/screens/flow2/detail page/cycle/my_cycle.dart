import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

import 'edit_period.dart';

class MyCyclesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int currentDay= 8;
    return bgContainer(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Cycles', style: TextStyle(color: Colors.black)),
        leading: CircleAvatar(
          backgroundColor: Color(0xffFFC4E8),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.white,
             // width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'My Cycles',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  CustomButton2(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CalendarViewPage()),
                      );
                    },
                    backgroundColor: primaryColor,
                    text:  "+ Add Period",
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            Container(
              padding: EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('History', style: TextStyle(fontSize: 16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FilterChip(label: Text('All'), onSelected: (_) {}),
                      SizedBox(width: 8),
                      FilterChip(label: Text('Period'), onSelected: (_) {}),
                      SizedBox(width: 8),
                      FilterChip(label: Text('Ovulation'), onSelected: (_) {}),
                      SizedBox(width: 8),
                      FilterChip(label: Text('Fertile'), onSelected: (_) {}),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text('2024', style: TextStyle(fontSize: 16)),

                  Row(
                    children: List.generate(31, (index) {
                      int day = index + 1; // Days are 1-indexed, starting from 1 to 31
                      return Expanded(
                        flex: 1, // Equal width for each day
                        child: Container(
                          height: 8.0, // Height of the progress bar
                          color: _getProgressColor(day), // Dynamic color based on situation
                        ),
                      );
                    }),
                  )




                ],
              ),
            ),
          ],
        ),

      ),
    ));
  }
}


// Function to determine the color based on the situation and day
Color _getProgressColor(int day) {
String situation = "Fertile"; // You can change this based on your condition

if (situation == "Fertile") {
// Fertile: Yellow from day 5 to 10
if (day >= 5 && day <= 10) {
return Colors.yellow;
}
// Ovulation: Pink on day 14
else if (day == 14) {
return Colors.pink;
}
// Period: Red from day 1 to 5
else if (day >= 1 && day <= 5) {
return Colors.red;
}
// Unfilled space (default grey for unfilled)
else {
return Colors.grey[300] ?? Colors.grey;
}
} else if (situation == "Ovulation") {
// Ovulation: Pink only on day 14
if (day == 14) {
return Colors.pink;
}
// Unfilled space
else {
return Colors.grey[300] ?? Colors.grey;
}
} else if (situation == "Period") {
// Period: Red from day 1 to 5
if (day >= 1 && day <= 5) {
return Colors.red;
}
// Unfilled space
else {
return Colors.grey[300] ?? Colors.grey;
}
} else {
// Default grey for unfilled space
return Colors.grey[300] ?? Colors.grey;
}
}

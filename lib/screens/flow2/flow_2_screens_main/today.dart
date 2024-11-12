import 'package:flutter/material.dart';
import '../../../widgets/cycle_phase_card.dart';

import '../../globals.dart' as globals;

class CycleStatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menstrual Cycle Tracker'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'), // Use AssetImage for local images
            fit: BoxFit.cover, // Adjust the fit as needed (cover, contain, fill, etc.)
          ),
        ),

        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Image.asset("assets/cal.png"),
                  Positioned(
                    top: 130, // Adjust this value to position vertically
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Text(
                          "13 Days Left",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.black), // Style as needed
                        ),
                        SizedBox(height: 5), // Add space between texts
                        Text(
                          "Next periods will start on",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black), // Style as needed
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Cycle Phase Section
                      SizedBox(
                        height: 120, // Adjust height as needed
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            SizedBox(height: 20),

                            // Displaying Cycle Phase Cards
                            CyclePhaseCard(
                              icon: Icons.favorite, // Example icon for menstrual phase
                              color: Colors.red[100]!, // Example color for menstrual phase
                              phase: "Menstrual Phase",
                              date: "Start Date: ${globals.lastPeriodStartDate.toLocal().toShortDateString()}",
                            ),
                            SizedBox(height: 10), // Space between cards
                            CyclePhaseCard(
                              icon: Icons.fiber_manual_record, // Example icon for follicular phase
                              color: Colors.green[100]!, // Example color for follicular phase
                              phase: "Follicular Phase",
                              date: "Start Date: ${globals.lastPeriodStartDate.add(Duration(days: globals.selectedDays)).toLocal().toShortDateString()}",
                            ),
                            SizedBox(height: 10),
                            CyclePhaseCard(
                              icon: Icons.beach_access, // Example icon for ovulation phase
                              color: Colors.blue[100]!, // Example color for ovulation phase
                              phase: "Ovulation Phase",
                              date: "Start Date: ${globals.lastPeriodStartDate.add(Duration(days: globals.selectedDays + 14)).toLocal().toShortDateString()}",
                            ),
                            SizedBox(height: 10),
                            CyclePhaseCard(
                              icon: Icons.wb_sunny, // Example icon for luteal phase
                              color: Colors.orange[100]!, // Example color for luteal phase
                              phase: "Luteal Phase",
                              date: "Start Date: ${globals.lastPeriodStartDate.add(Duration(days: globals.selectedDays + 14 + 1)).toLocal().toShortDateString()}",
                            ),

                            // Any other widgets you might want to keep
                            Spacer(), // To push any additional content to the bottom
                            ElevatedButton(
                              onPressed: () {
                                // Action for the button, e.g., navigate to another screen
                              },
                              child: Text("Next Step"),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      // Today - Cycle Day 11 Section
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today - Cycle Day 11',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'HIGH - Chance of getting periods',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(height: 16),

                            // Progress Bar
                            Row(
                              children: [
                                Text("Oct 3"),
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: 0.55, // Adjust this value as needed
                                    color: Colors.pink,
                                    backgroundColor: Colors.grey[300],
                                  ),
                                ),
                                Text("Today"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
 
}

extension on DateTime {
  String toShortDateString() {
    return "${this.day}/${this.month}/${this.year}";
  }}

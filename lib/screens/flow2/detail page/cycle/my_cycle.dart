import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_period.dart';

class MyCyclesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                          MaterialPageRoute(
                              builder: (context) => CalendarScreen()),
                        );
                      },
                      backgroundColor: primaryColor,
                      text: "+ Add/Edit Periods",
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Consumer<CycleProvider>(
                builder: (context, cycleProvider, child) {
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('History', style: TextStyle(fontSize: 16)),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
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
                            ),
                            SizedBox(height: 10),
                            // Display the current month and year dynamically
                            Text(
                              "${DateTime.now().month}/${DateTime.now().year}",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: List.generate(31, (index) {
                                int day = index + 1; // Days are 1-indexed
                                return Expanded(
                                  flex: 1, // Equal width for each day
                                  child: Container(
                                    height: 8.0, // Height of the progress bar
                                    color: _getProgressColor(day, cycleProvider),
                                  ),
                                );
                              }),
                            ),

                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildLegend(), // Add the legend below the progress bar
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getProgressColor(int day, CycleProvider cycleProvider) {
    DateTime currentDay =
    DateTime(DateTime.now().year, DateTime.now().month, day);

    if (cycleProvider.periodDays.contains(currentDay)) {
      return Colors.red; // Period days
    } else if (cycleProvider.fertileDays.contains(currentDay)) {
      return Colors.yellow; // Fertile days
    } else if (cycleProvider.predictedDays.contains(currentDay)) {
      return Colors.pink; // Predicted ovulation days
    } else {
      return Colors.grey[300] ?? Colors.grey; // Default color for other days
    }
  }

  // Builds a legend for the progress bar
  Widget _buildLegend() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLegendItem(Colors.red, "Period Days"),
          _buildLegendItem(Colors.yellow, "Fertile Days"),
          _buildLegendItem(Colors.pink, "Ovulation Days"),
          _buildLegendItem(Colors.grey[300] ?? Colors.grey, "Other Days"),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}

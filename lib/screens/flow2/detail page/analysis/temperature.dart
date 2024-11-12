import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../globals.dart';

class tempChart extends StatelessWidget {
  const tempChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Temperature"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,  // Remove shadow for a cleaner gradient effect
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFE8EAF6),

                Color(0xFFF3E5F5)
              ], // Light gradient background
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

      ),

      body: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          image: DecorationImage(

            image: AssetImage('assets/bg.jpg'),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            colors: [Color(0xFFE8EAF6), Color(0xFFF3E5F5)], // Light gradient background
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             SizedBox(height: 10),
            Container(
              height: 200,
              color: Colors.white,
              padding: EdgeInsets.all(15),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceEvenly,
                  maxY: 100.0, // Set to max temperature for a consistent scale
                  minY: 98.5,  // Set to min temperature to match the y-axis
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 0.1,  // Tighter intervals for temperature values
                        getTitlesWidget: (value, _) => Text(
                          value.toStringAsFixed(1),
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false), // Hide bottom titles
                    ),
                  ),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: 98.9,
                          gradient: LinearGradient(
                            colors: [Colors.red, Colors.red.withOpacity(0)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          width: 12,
                          borderRadius: BorderRadius.zero,
                        ),
                      ],
                      barsSpace: 6, // Add spacing between bars
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: 99.1,
                          gradient: LinearGradient(
                            colors: [Colors.red, Colors.red.withOpacity(0)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          width: 12,
                          borderRadius: BorderRadius.zero,
                        ),
                      ],
                      barsSpace: 6,
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: 99.3,
                          gradient: LinearGradient(
                            colors: [Colors.red, Colors.red.withOpacity(0)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          width: 12,
                          borderRadius: BorderRadius.zero,
                        ),
                      ],
                      barsSpace: 6,
                    ),
                    BarChartGroupData(
                      x: 3,
                      barRods: [
                        BarChartRodData(
                          toY: 99.7,
                          gradient: LinearGradient(
                            colors: [Colors.red, Colors.red.withOpacity(0)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          width: 12,
                          borderRadius: BorderRadius.zero,
                        ),
                      ],
                      barsSpace: 6,
                    ),
                    BarChartGroupData(
                      x: 4,
                      barRods: [
                        BarChartRodData(
                          toY: 100.0,
                          gradient: LinearGradient(
                            colors: [Colors.red, Colors.red.withOpacity(0)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          width: 12,
                          borderRadius: BorderRadius.zero,
                        ),
                      ],
                      barsSpace: 6,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 15),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Oct 23", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text("99.0 °F", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 15),
            Text("Cycle Day 21"),

            SizedBox(height: 15),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: secondaryColor,

              ),
               child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Intercourse", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Unprotected", style: TextStyle(fontSize: 18, color: Colors.pink, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


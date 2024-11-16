import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../globals.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TempChart extends StatelessWidget {
  const TempChart({super.key});

  @override
  Widget build(BuildContext context) {
    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Temperature", style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          leading: IconButton(
            icon: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Color(0xFFFFC4E8),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(Icons.arrow_back),
            ),
            onPressed: () => Navigator.pop(context),
          ),

        ),
        body: ListView(
          scrollDirection: Axis.vertical,

          children: [
            const SizedBox(height: 10),
            // Temperature Chart
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(15),
              child:   LineChart(
                LineChartData(
                  minY: 98, // Adjust this based on your data
                  maxY: 100,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toStringAsFixed(1)}',
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            'Day ${value.toInt()}',
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(1, 98.0), // Starting point
                        const FlSpot(5, 98.5), // Linear increase
                        const FlSpot(10, 99.5), // Steep increase
                        const FlSpot(15, 99.0), // Drop
                      ],
                      isCurved: false, // Make the line straight
                      barWidth: 2.5, // Adjust the line thickness
                      color: Colors.red, // Line color
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.red.withOpacity(0.5), // Top color of the gradient
                            Colors.red.withOpacity(0.0), // Bottom transparent
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      dotData: FlDotData(
                        show: true,
                         // Dot color
                      ),
                    ),
                  ],
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 0.2, // Adjust grid spacing
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.2), // Light grid lines
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                ),
              )
            ),

            const SizedBox(height: 15),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Oct 23", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text("99.0 °F", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 15),
            const Text("Cycle Day 21"),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.pink.withOpacity(0.1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Intercourse", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                    "Unprotected",
                    style: TextStyle(fontSize: 18, color: Colors.pink, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
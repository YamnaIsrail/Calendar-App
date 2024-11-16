import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../globals.dart';

class IntercourseAnalysis extends StatelessWidget {
  const IntercourseAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
         title:  Text(
            "Analysis",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,

          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Intercourse Chart",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Line chart container
              Container(
                height: 150,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            return Text((9 + value.toInt()).toString());
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        spots: [
                          FlSpot(0, 2),
                          FlSpot(1, 2),
                          FlSpot(2, 1),
                          FlSpot(3, 3),
                          FlSpot(4, 1),
                          FlSpot(5, 3),
                          FlSpot(6, 2),
                        ],
                        color: primaryColor,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                      ),
                    ],
                    minY: 0,
                    maxY: 3,
                    minX: 0,
                    maxX: 6,
                  ),
                ),
              ),
              Divider(height: 30),
              Text(
                "Intercourse Activity",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ActivityColumn(label: "3x", description: "Intercourse"),
                  ActivityColumn(label: "0%", description: "Female Orgasm"),
                  ActivityColumn(label: "0x", description: "Protected"),
                  ActivityColumn(label: "3x", description: "Unprotected"),
                ],
              ),
              SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Show / Hide",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom widget for each activity column
class ActivityColumn extends StatelessWidget {
  final String label;
  final String description;

  const ActivityColumn({required this.label, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(description),
      ],
    );
  }
}

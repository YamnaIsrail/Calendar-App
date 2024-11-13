import 'package:flutter/material.dart';

import 'LineChart.dart';
class CervicalMucusSection extends StatelessWidget {
  final String mucusType;
  final String chanceOfConception;
  final List<double> chartData;

  CervicalMucusSection({required this.mucusType, required this.chanceOfConception, required this.chartData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Cervical Mucus", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text("Type: $mucusType"),
        SizedBox(height: 4),
        Text("Chance of Conception: $chanceOfConception"),
        SizedBox(height: 16),
        Container(
          height: 100,
          child: CustomLineChart(data: chartData),
        ),
      ],
    );
  }
}

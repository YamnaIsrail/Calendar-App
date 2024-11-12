import 'package:calender_app/screens/globals.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class weekWeight extends StatelessWidget {
  const weekWeight({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weight"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0, // Remove shadow for a cleaner gradient effect
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
            colors: [
              Color(0xFFE8EAF6),
              Color(0xFFF3E5F5)
            ], // Light gradient background
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                    minY: 98.5, // Set to min temperature to match the y-axis
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval:
                          0.1, // Tighter intervals for temperature values
                          getTitlesWidget: (value, _) => Text(
                            value.toStringAsFixed(1),
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles:
                        SideTitles(showTitles: false), // Hide bottom titles
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
              Container(
                padding: EdgeInsets.all(20),
                // height: 80,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(

                      child: ElevatedButton( style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: const Size(double.infinity, 50), // Full width with minimum height
                      ),


                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => weekWeight()));
                          },
                          child: Text("Week", style: TextStyle(color: Colors.white),)),
                    ),
                    SizedBox(width: 15,),
                    Expanded(

                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: secondaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            minimumSize: const Size(double.infinity, 50), // Full width with minimum height
                          ),

                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => weekWeight()));
                          },
                          child: Text("Month")),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Oct 23",
                      style:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text("65 kg",
                      style:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                child: Column(
                  children: [
                    Text("BMI", style: TextStyle(fontSize: 18)),
                    Container(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true, interval: 1),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                            ),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              isCurved: true,
                              color: Colors.blueAccent,
                              barWidth: 3,
                              dotData: FlDotData(show: false),
                              spots: [
                                FlSpot(0, 64),
                                FlSpot(1, 63.8),
                                FlSpot(2, 64.2),
                                FlSpot(3, 65),
                                FlSpot(4, 64.5),  // example data points
                              ],
                            ),
                          ],
                        ),
                      ),

                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Moderately Obese",
                            style: TextStyle(color: Colors.orange)),
                        // Color bar with indicators goes here
                      ],
                    ),
                    Text("Height: 5'3.0\" ft + in."),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

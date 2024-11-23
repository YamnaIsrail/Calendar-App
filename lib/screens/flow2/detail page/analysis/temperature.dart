import 'package:calender_app/provider/intercourse_provider.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:calender_app/provider/analysis/temperature_provider.dart';

class TempChart extends StatelessWidget {
  const TempChart({super.key});

  @override
  Widget build(BuildContext context) {
    final temperatureProvider = Provider.of<TemperatureProvider>(context);
    final intercourseProvider = Provider.of<IntercourseProvider>(context);

    // Check if temperature data is available, else display a message
    String latestTemperature = temperatureProvider.temperatureData.isNotEmpty
        ? "${temperatureProvider.getLatestTemperature()} °F"
        : "Not Entered Yet";

    // Cycle Day and Intercourse data
    String cycleDay = intercourseProvider.intercourseActivityData.isNotEmpty
        ? "Cycle Day ${intercourseProvider.intercourseActivityData.last['times']}"
        : "Cycle Day  _";

    String intercourseInfo = intercourseProvider
            .intercourseActivityData.isNotEmpty
        ? "${intercourseProvider.intercourseActivityData.last['condomOption']} - ${intercourseProvider.intercourseActivityData.last['femaleOrgasm']}"
        : "Not Entered Yet";

    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            "Temperature",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: const Color(0xFFFFC4E8),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(Icons.arrow_back),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ListView(
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
              child: LineChart(
                LineChartData(
                  minY: temperatureProvider.temperatureData.isNotEmpty
                      ? temperatureProvider.temperatureData.map((e) => e['temperature']).reduce((a, b) => a < b ? a : b) - 1 // Slight padding
                      : 97, // Default minimum when no data
                  maxY: temperatureProvider.temperatureData.isNotEmpty
                      ? temperatureProvider.temperatureData.map((e) => e['temperature']).reduce((a, b) => a > b ? a : b) + 1 // Slight padding
                      : 101, // Default maximum when no data
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
                      spots: List.generate(
                        temperatureProvider.temperatureData.length,
                            (index) {
                          double temperature =
                          temperatureProvider.temperatureData[index]['temperature'];
                          return FlSpot(index + 1.0, temperature);
                        },
                      ),
                      isCurved: true,
                      barWidth: 2.5,
                      color: Colors.red,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.red.withOpacity(0.5),
                            Colors.red.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      dotData: FlDotData(
                        show: true,
                      ),
                    ),
                  ],
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 0.2,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.2),
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
              ),
            ),

            const SizedBox(height: 15),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Display dynamic date or "Not Entered Yet" message
                Text(
                  temperatureProvider.temperatureData.isNotEmpty
                      ? DateFormat('yyyy-MM-dd').format(DateTime.parse(
                          temperatureProvider.getLatestTemperatureDate()))
                      : "",
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),

                // Display dynamic temperature or button to add info if empty
                temperatureProvider.temperatureData.isNotEmpty
                    ? Column(
                        children: [
                          Text(
                            latestTemperature, // Show the latest temperature
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Show dialog or navigate to screen to add temperature info
                              _showAddTemperatureDialog(context, temperatureProvider);
                            },
                            child: const Text("Add More"),
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    : ElevatedButton(
                        onPressed: () {
                          // Show dialog or navigate to screen to add temperature info
                          _showAddTemperatureDialog(
                              context, temperatureProvider);
                        },
                        child: const Text("Add Info"),
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              cycleDay,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 15),

               Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.pink.withOpacity(0.1),
                ),
                child:  SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Intercourse: $intercourseInfo  ",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      intercourseProvider.intercourseActivityData.isNotEmpty
                          ? "Details Available"
                          : "Not Entered Yet",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTemperatureDialog(
      BuildContext context, TemperatureProvider temperatureProvider) {
    TextEditingController temperatureController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Temperature'),
          content: TextField(
            controller: temperatureController,
            decoration: const InputDecoration(hintText: "Enter Temperature"),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                double temperature =
                    double.tryParse(temperatureController.text.trim()) ?? 0.0;

                if (temperature > 0) {
                  // Automatically use today's date
                  String currentDate =
                      DateFormat('yyyy-MM-dd').format(DateTime.now());

                  temperatureProvider.addTemperature(temperature, currentDate);
                  Navigator.pop(context); // Close the dialog
                } else {
                  print("Invalid temperature. Please enter a valid value.");
                }
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

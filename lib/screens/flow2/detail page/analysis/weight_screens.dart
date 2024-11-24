import 'package:calender_app/provider/analysis/weight_provider.dart';
import 'package:flutter/material.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'progress_bar.dart';

class Weight extends StatefulWidget {
  const Weight({super.key});

  @override
  State<Weight> createState() => _WeightState();
}

class _WeightState extends State<Weight> {
  List<Map<String, dynamic>> weightData = [];
  late Box weightBox;
  String _selectedView = 'month';  // State variable to track the selected view

  @override
  void initState() {
    super.initState();
    initializeHive();
  }

  Future<void> initializeHive() async {
    weightBox = await Hive.openBox('weightBox');
    setState(() {
      weightData = List<Map<String, dynamic>>.from(
          weightBox.get('weights', defaultValue: []));
    });
  }
  Map<String, dynamic>? getLastWeekData() {
    List<Map<String, dynamic>> weeklyData = weightData
        .where((entry) =>
    entry['date']
        .isAfter(DateTime.now().subtract(const Duration(days: 7))) &&
        entry['date'].isBefore(DateTime.now().add(const Duration(days: 1))))
        .toList();

    if (weeklyData.isNotEmpty) {
      // Sort by date to get the most recent entry
      weeklyData.sort((a, b) => b['date'].compareTo(a['date']));
      return weeklyData.first;
    }
    return null;
  }

  void updateWeight(double weight) {
    setState(() {
      final date = DateTime.now();
      weightData.add({'date': date, 'weight': weight});
      weightBox.put('weights', weightData);
    });
  }
  void showWeightInputDialog() {
    TextEditingController weightController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Enter Weight"),
        content: TextField(
          controller: weightController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Weight in kg"),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
              ),
              Expanded(
                child: CustomButton(
                    onPressed: () {

                      if (weightController.text.isNotEmpty) {
                        double weight = double.parse(weightController.text);
                        updateWeight(weight);
                        Provider.of<WeightProvider>(context, listen: false)
                            .addWeightData(weight);
                        Navigator.pop(context);
                      }
                    },
                    backgroundColor: primaryColor,
                    text: "Save"
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }
  double userHeight = 170.0; // Initial height value
  final double maxHeight = 200.0; // Maximum height reference
  bool isHeightInputEnabled = false; // Toggle for enabling height input

  // Calculate the progress based on the user's height
  double calculateHeightProgress(double userHeight) {
    return userHeight / maxHeight;
  }

  // Show height input dialog
  void showHeightInputDialog() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController heightController = TextEditingController();
        return AlertDialog(
          title: Text('Enter your height'),
          content: TextField(
            controller: heightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Height in cm"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  userHeight = double.tryParse(heightController.text) ?? userHeight;
                });
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = calculateHeightProgress(userHeight);

    final lastWeekData = Provider.of<WeightProvider>(context).getLastWeightData();

    return  bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Weight", style: TextStyle(fontWeight: FontWeight.bold)),
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
            Container(
              height: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(
                    _selectedView == 'week' ? 'Week View' : 'Month View',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  _selectedView == 'week' ? buildWeeklyView() : buildMonthlyView(),
                ],
              ),
            ),
            FloatingActionButton(
              onPressed: showWeightInputDialog,
              child: const Text("Add weight +"),
            ),
            const SizedBox(height: 15),
            Divider(),
            Container(
              padding: EdgeInsets.all(20),
              // height: 80,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton2(text: "Month",
                      backgroundColor: secondaryColor,
                      onPressed: () {
                        setState(() {
                          _selectedView = 'month';  // Switch to the month view
                        });
                      }
                    ),
                  ),

                  SizedBox(width: 15,),
                  Expanded(
                    child: CustomButton2(text: "Week",
                      backgroundColor: primaryColor,
                      onPressed: ()  {
                        setState(() {
                          _selectedView = 'week';  // Switch to the week view
                        });
                      },
                    ),
                  ),

                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text(
                    lastWeekData != null ? "${lastWeekData['weight']} kg" : 'No weight recorded',
                    style:
                    TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text(

                    lastWeekData != null
                        ? DateFormat('yyyy-MM-dd').format(lastWeekData['date']) // Only date
                        : 'No data available',

                    style:
                    TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xffC6E1FC),
                borderRadius: BorderRadius.circular(12),
              ),

              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [

                  SwitchListTile(
                    title: Text("BMI"),
                    value: isHeightInputEnabled,
                    onChanged: (value) {
                      setState(() {
                        isHeightInputEnabled = value;
                      });
                      if (isHeightInputEnabled) {
                        showHeightInputDialog();
                      }
                    },
                  ),
                  Container(
                      child: MultiColorProgressBar(progress: progress)
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        " Height",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text("  ${userHeight.toStringAsFixed(1)} cm",
                          style: TextStyle(color:Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWeeklyView() {
    List<double> weeklyWeights = weightData
        .where((entry) =>
    entry['date']
        .isAfter(DateTime.now().subtract(const Duration(days: 7))) &&
        entry['date'].isBefore(DateTime.now().add(const Duration(days: 1))))
        .map((entry) => entry['weight'] as double)
        .toList();

    double progress = 0;
    if (weeklyWeights.isNotEmpty) {
      // Calculate progress (example: increase by 10% per day with weight logged)
      progress = (weeklyWeights.length / 7) * 100;
    }

    return weeklyWeights.isEmpty
        ?
    // const Center(child: Text("No data for this week")
    Center(
      child: Text(
        "No data available.",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),

    )
        :    Expanded(
      child: LineChart(
        LineChartData(
          minY: weeklyWeights.reduce((a, b) => a < b ? a : b) - 5,
          maxY: weeklyWeights.reduce((a, b) => a > b ? a : b) + 5,
          lineBarsData: [
            LineChartBarData(
              spots: weeklyWeights
                  .asMap()
                  .entries
                  .map((entry) =>
                  FlSpot(entry.key.toDouble(), entry.value))
                  .toList(),
              isCurved: true,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.5),
                    Colors.blue.withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final int index = value.toInt();
                  if (index >= 0 && index < weeklyWeights.length) {
                    return Text(
                      "${weightData[index]['date'].day}/${weightData[index]['date'].month}",
                      style: const TextStyle(fontSize: 10),
                    );
                  }
                  return const Text("");
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) =>
                    Text("${value.toInt()} kg", style: TextStyle(fontSize: 12),),
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
        ),
      ),


    );
  }


  Widget buildMonthlyView() {
    List<Map<String, dynamic>> monthlyData = weightData
        .where((entry) =>
    entry['date'].month == DateTime.now().month &&
        entry['date'].year == DateTime.now().year)
        .toList();

    double progress = 0;
    if (monthlyData.isNotEmpty) {
      // Calculate progress for monthly data
      progress = (monthlyData.length / DateTime.now().day) * 100;
    }

    return monthlyData.isEmpty
        ? const Center(child: Text("No data for this month"))
        :   Expanded(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(5),

          child: LineChart(
            LineChartData(
              minY: monthlyData
                  .map((e) => e['weight'])
                  .reduce((a, b) => a < b ? a : b) - 5,
              maxY: monthlyData
                  .map((e) => e['weight'])
                  .reduce((a, b) => a > b ? a : b) + 5,
              lineBarsData: [
                LineChartBarData(
                  spots: monthlyData
                      .asMap()
                      .entries
                      .map((entry) =>
                      FlSpot(entry.key.toDouble(),
                          entry.value['weight'] as double))
                      .toList(),
                  isCurved: true,
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.withOpacity(0.5),
                        Colors.green.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
              ],
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      final int index = value.toInt();

                      // Show the title for every nth data point
                      int step = (monthlyData.length / 5).ceil();
                      if (index % step == 0 && index < monthlyData.length) {
                        final date = monthlyData[index]['date'];
                        return Text(
                          "${date.day}/${date.month}",
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }
                      return const Text(""); // Empty space for non-visible titles
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) =>
                        Text("${value.toInt()} kg"),
                  ),
                ),
              ),
              gridData: const FlGridData(show: false),
            ),
          ),
        ));
  }

}


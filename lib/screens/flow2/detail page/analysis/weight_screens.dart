import 'package:calender_app/provider/analysis/weight_provider.dart';
import 'package:flutter/material.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class Weight extends StatefulWidget {
  const Weight({super.key});

  @override
  State<Weight> createState() => _WeightState();
}

class _WeightState extends State<Weight> {
  List<Map<String, dynamic>> weightData = [];
  late Box weightBox;
  String _selectedView = 'month';  // State variable to track the selected view
  double userHeight = 0; // Initial height value

  @override
  void initState() {
    super.initState();
    initializeHive();
  }
  Future<void> initializeHive() async {
    try {
      weightBox = await Hive.openBox('weightBox');
      setState(() {
        userHeight = weightBox.get('height', defaultValue: 0.0);

        // Safely retrieve and cast 'weights' data
        final weights = weightBox.get('weights', defaultValue: []);
        if (weights is List) {
          weightData = weights
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
        } else {
          weightData = [];
        }
      });
    } catch (e) {
      // print("Error initializing Hive: $e");
    }
  }

  Future<void> updateWeight(double weight) async {
    final date = DateTime.now();
    double bmi = weight / ((userHeight / 100) * (userHeight / 100)); // Calculate BMI using the current height
    String stage = calculateBMIStage(weight, userHeight);

    Map<String, dynamic> newWeightRecord = {
      'date': date.toIso8601String(), // Save date as string for better compatibility
      'weight': weight,
      'bmi': bmi.toStringAsFixed(1),
      'stage': stage,
    };

    weightData.add(newWeightRecord);

    // Save the weights list and ensure type consistency
    await weightBox.put('weights', weightData.map((e) => Map<String, dynamic>.from(e)).toList());

    final weightProvider = Provider.of<WeightProvider>(context, listen: false);
    weightProvider.updateLatestWeight(weight, date);

    setState(() {});
  }


  String calculateBMIStage(double weight, double heightCm) {
    if (heightCm <= 0) {
      return " ";
    }
    double heightM = heightCm / 100;
    double bmi = weight / (heightM * heightM);

    if (bmi < 18.5) {
      return "Underweight";
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return "Normal";
    } else if (bmi >= 25.0 && bmi < 29.9) {
      return "Overweight";
    } else {
      return "Obese";
    }
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (weightController.text.isNotEmpty) {
                double weight = double.parse(weightController.text);
                updateWeight(weight);
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
  void showHeightInputDialog() {
    TextEditingController heightController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter your height'),
          content: TextField(
            controller: heightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Height in cm"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  userHeight = double.tryParse(heightController.text) ?? userHeight;
                  weightBox.put('height', userHeight);
                });
                // Recalculate BMI for the last weight entry
                if (weightData.isNotEmpty) {
                  final lastWeightData = weightData.last;
                  double weight = lastWeightData['weight'];
                  lastWeightData['bmi'] = (weight / ((userHeight / 100) * (userHeight / 100))).toStringAsFixed(1);
                  lastWeightData['stage'] = calculateBMIStage(weight, userHeight);
                  weightBox.put('weights', weightData); // Update the weights in Hive
                }
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
  bool isHeightInputEnabled = true; // Toggle for enabling height input


  @override
  Widget build(BuildContext context) {
    final lastWeightData = weightData.isNotEmpty ? weightData.last : null;

    return bgContainer(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Weight", style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          children: [
            Container(
              height: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all( 15),
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lastWeightData != null && lastWeightData['weight'] != null
                      ? "${lastWeightData['weight']} kg"
                      : 'No weight recorded',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                if (isHeightInputEnabled)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      if(userHeight!=0)
                        Text(
                          lastWeightData != null && lastWeightData['bmi'] != null && lastWeightData['stage'] != null
                              ? "BMI: ${lastWeightData['bmi']}"
                              : '',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      Text(
                        lastWeightData != null && lastWeightData['bmi'] != null && lastWeightData['stage'] != null
                            ? " ${lastWeightData['stage']}"
                            : 'BMI: N/A',
                        style: lastWeightData != null && lastWeightData['bmi'] != null && lastWeightData['stage'] != null
                            ? const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, ) // Style for stage
                            : const TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.red), // Style for 'Enter Height'
                      ),

                    ],
                  )
                else
                  Text("Enable BMI tracking")

              ]

              ,
            ),
            Container(
              padding: EdgeInsets.all(20),
              // height: 80,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton2(text: "Month",
                        backgroundColor: _selectedView == 'month' ? primaryColor : secondaryColor,
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
                      backgroundColor: _selectedView == 'week' ? primaryColor : secondaryColor,

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

                    },
                  ),

                  // Container(
                  //     child: MultiColorProgressBar(progress: progress)
                  // ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        " Height",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      userHeight > 0
                          ? Row(
                            children: [
                              Text("  ${userHeight.toStringAsFixed(1)} cm",
                              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: showHeightInputDialog,
                              ),
                            ],
                          )
                          : IconButton(
                        icon: Icon(Icons.add),
                        onPressed: showHeightInputDialog,
                      ),

                      //     style: TextStyle(color:Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
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
    DateTime now = DateTime.now();
    List<Map<String, dynamic>> weeklyData = weightData.where((entry) {
      final entryDate = entry['date'] is DateTime
          ? entry['date'] as DateTime
          : DateTime.parse(entry['date']);
      return entryDate.isAfter(now.subtract(const Duration(days: 7))) &&
          entryDate.isBefore(now.add(const Duration(days: 1)));
    }).toList();

    if (weeklyData.isEmpty) {
      return Center(
        child: Text("No data available.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      );
    }

    return Expanded(
      child: LineChart(
        LineChartData(
          minY: weeklyData.map((e) => e['weight']).reduce((a, b) => a < b ? a : b) - 5,
          maxY: weeklyData.map((e) => e['weight']).reduce((a, b) => a > b ? a : b) + 5,
          lineBarsData: [
            LineChartBarData(
              spots: weeklyData.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> data = entry.value;
                return FlSpot(index.toDouble(), data['weight']);
              }).toList(),
              isCurved: true,
              dotData: FlDotData(show: true),
            ),
          ],
          titlesData: FlTitlesData(
        topTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false, // Hide top titles
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false, // Hide left titles
        ),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true, // Show right titles
          getTitlesWidget: (value, meta) {
            return Text(
              "${value.toInt()}", // Add "kg" to the right titles
              style: const TextStyle(fontSize: 10),
            );
          },
        ),
      ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  if (value % 1 == 0) { // Only process whole numbers
                    final int index = value.toInt();
                    return Text(
                      index.toString(),
                      style: const TextStyle(fontSize: 10),
                    );
                  }
                  return const SizedBox.shrink(); // Hide fractional values
                },
              ),
            ),

          ),
      ),
    )
    );
  }
  Widget buildMonthlyView() {
    DateTime now = DateTime.now();
    List<Map<String, dynamic>> monthlyData = weightData.where((entry) {
      final entryDate = entry['date'] is DateTime
          ? entry['date'] as DateTime
          : DateTime.parse(entry['date']);
      return entryDate.isAfter(now.subtract(const Duration(days: 30))) &&
          entryDate.isBefore(now.add(const Duration(days: 1)));
    }).toList();

    if (monthlyData.isEmpty) {
      return const Center(child: Text("No data for this month"));
    }

    return Expanded(
      child: LineChart(
        LineChartData(
          minY: monthlyData.map((e) => e['weight']).reduce((a, b) => a < b ? a : b) - 5,
          maxY: monthlyData.map((e) => e['weight']).reduce((a, b) => a > b ? a : b) + 5,
          lineBarsData: [
            LineChartBarData(
              spots: monthlyData.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> data = entry.value;
                return FlSpot(index.toDouble(), data['weight'] as double);
              }).toList(),
              isCurved: true,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [Colors.green.withOpacity(0.5), Colors.green.withOpacity(0.1)],
                ),
              ),
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  if (value % 1 == 0) { // Only process whole numbers
                    final int index = value.toInt();
                    return Text(
                      index.toString(),
                      style: const TextStyle(fontSize: 10),
                    );
                  }
                  return const SizedBox.shrink(); // Hide fractional values
                },
              ),
            ),

            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
                getTitlesWidget: (value, _) {
                  final int index = value.toInt();
                  int step = (monthlyData.length / 5).ceil();
                  if (index % step == 0 && index < monthlyData.length) {
                    final date = monthlyData[index]['date'] is DateTime
                        ? monthlyData[index]['date'] as DateTime
                        : DateTime.parse(monthlyData[index]['date'] as String);
                    return Text(
                      "${date.day}/${date.month}",
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                    );
                  }
                  return const Text(""); // Empty space for non-visible titles
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
                getTitlesWidget: (value, _) => Text("${value.toInt()} kg"),
              ),
            ),
             ),
          gridData: const FlGridData(show: false),
        ),
      ),
    );
  }

}

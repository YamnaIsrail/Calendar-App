import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class WeightView extends StatefulWidget {
  const WeightView({super.key});

  @override
  State<WeightView> createState() => _WeightViewState();
}

class _WeightViewState extends State<WeightView> {
  List<Map<String, dynamic>> weightData = [];
  late Box weightBox;

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
  // Get last weight and date for the current week
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: bgContainer(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text("Weight Tracker"),
            bottom: const TabBar(

              tabs: [
                Tab(text: "Weekly"),
                Tab(text: "Monthly"),
              ],
            ),
          ),
          body: weightData.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "No data available.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  onPressed: showWeightInputDialog,
                  backgroundColor: primaryColor,
                  text: "Add Weight"
                ),

              ],
            ),
          )
              : TabBarView(
            children: [
              buildWeeklyView(),
              buildMonthlyView(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: showWeightInputDialog,
            child: const Icon(Icons.add),
          ),
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
        ? const Center(child: Text("No data for this week"))
        : Column(
      children: [
        Expanded(
          child: Container(
            height: 350,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(15),
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
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Weekly Progress",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: progress / 100,
                minHeight: 10,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const SizedBox(height: 10),
              Text("${progress.toStringAsFixed(1)}% completed"),
            ],
          ),
        ),
      ],
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
        : Container(
          child: Column(
                children: [
          Expanded(
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
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Monthly Progress",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: progress / 100,
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.green),
                ),
                const SizedBox(height: 10),
                Text("${progress.toStringAsFixed(1)}% completed"),
              ],
            ),
          ),
                ],
              ),
        );
  }


}

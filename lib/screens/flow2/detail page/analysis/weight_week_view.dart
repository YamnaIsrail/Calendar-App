import 'package:calender_app/screens/flow2/detail%20page/analysis/weight_week_view.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'progress_bar.dart';
import 'weight_months_view.dart';

import 'package:hive/hive.dart';
//
// class weekWeight extends StatelessWidget {
//   const weekWeight({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return  bgContainer(
//       child: Scaffold(
//           backgroundColor: Colors.transparent,
//           appBar: AppBar(
//             backgroundColor: Colors.transparent,
//             title: Text("Week View", style: TextStyle(fontWeight: FontWeight.bold)),
//             centerTitle: true,
//             leading: IconButton(
//               icon: Container(
//                 padding: EdgeInsets.all(3),
//                 decoration: BoxDecoration(
//                   color: Color(0xFFFFC4E8),
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//                 child: Icon(Icons.arrow_back),
//               ),
//               onPressed: () => Navigator.pop(context),
//             ),
//
//           ),
//           body: ListView(
//           scrollDirection: Axis.vertical,
//           children: [
//             const SizedBox(height: 10),
//             Container(
//               height: 350,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               padding: const EdgeInsets.all(15),
//               child: LineChart(
//                 LineChartData(
//                   minY: 60,
//                   maxY: 75,
//                   titlesData: FlTitlesData(
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, _) => Text("Day ${(value + 1).toInt()}"),
//                       ),
//                     ),
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, _) => Text("${value.toInt()} kg"),
//                       ),
//                     ),
//                   ),
//                   lineBarsData: [
//                     LineChartBarData(
//                       spots: [
//                         const FlSpot(0, 65),
//                         const FlSpot(1, 66),
//                         const FlSpot(2, 67),
//                         const FlSpot(3, 65),
//                       ],
//                       isCurved: true,
//                       belowBarData: BarAreaData(
//                         show: true,
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.blue.withOpacity(0.5),
//                             Colors.blue.withOpacity(0.1),
//                           ],
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                         ),
//                       ),
//                     ),
//                   ],
//                   gridData: const FlGridData(show: false),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             Divider(),
//             Container(
//               padding: EdgeInsets.all(20),
//               // height: 80,
//
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: CustomButton2(text: "Week",
//                       backgroundColor: secondaryColor,
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => weekWeight()));
//                       },),
//                   ),
//
//                   SizedBox(width: 15,),
//                   Expanded(
//                     child: CustomButton2(text: "Month",
//                       backgroundColor: primaryColor,
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => MonthWeight()));
//                       },),
//                   ),
//
//                 ],
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Oct 23",
//                     style:
//                     TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//                 Text("65 kg",
//                     style:
//                     TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//               ],
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 color: Color(0xffC6E1FC),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 children: [
//                   ListTile(
//                     title: Text("BMI", style: TextStyle(fontSize: 18)),
//                     trailing: Switch(value: true, onChanged: (value){}),  ),
//                   Text("Moderately Obese", style: TextStyle(color:Colors.orange, fontSize: 11, fontWeight: FontWeight.bold)),
//
//                   Container(
//                       child: MultiColorProgressBar(progress: 6)
//                   ),
//                   SizedBox(height: 10,),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("Height ",
//                           style: TextStyle(color:Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
//
//                       Text(" 5'3.0\" ft + in.",
//                           style: TextStyle(color:Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//
//
//                 ],
//               ),
//             ),
//           ],
//         ),
//           )
//     );
//   }
// }

class weekWeight extends StatefulWidget {
  const weekWeight({super.key});

  @override
  State<weekWeight> createState() => _weekWeightState();
}

class _weekWeightState extends State<weekWeight> {
  List<double> weightData = [];
  late Box weightBox;

  @override
  void initState() {
    super.initState();
    initializeHive();
  }

  Future<void> initializeHive() async {
    weightBox = await Hive.openBox('weightBox');
    setState(() {
      weightData = List<double>.from(weightBox.get('weights', defaultValue: []));
    });
  }

  void updateWeight(double weight) {
    setState(() {
      weightData.add(weight);
      if (weightData.length > 7) weightData.removeAt(0); // Keep weekly data
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Week Weight"),
        centerTitle: true,
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
            ElevatedButton(
              onPressed: showWeightInputDialog,
              child: const Text("Add Weight"),
            ),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: LineChart(
                LineChartData(
                  minY: weightData.reduce((a, b) => a < b ? a : b) - 5,
                  maxY: weightData.reduce((a, b) => a > b ? a : b) + 5,
                  lineBarsData: [
                    LineChartBarData(
                      spots: weightData
                          .asMap()
                          .entries
                          .map((entry) => FlSpot(
                          entry.key.toDouble(), entry.value))
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
                        getTitlesWidget: (value, _) =>
                            Text("Day ${(value + 1).toInt()}"),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) =>
                            Text("${value.toInt()} "),
                      ),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${DateTime.now().day}/ ${DateTime.now().month}",
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${weightData.last} kg",
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: showWeightInputDialog,
              child: const Text("Add More Weight"),
            ),
          ],
        ),
      ),
    );
  }
}

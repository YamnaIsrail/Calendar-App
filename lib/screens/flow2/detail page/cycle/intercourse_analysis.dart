import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/provider/intercourse_provider.dart';
import 'package:calender_app/screens/flow2/detail%20page/cycle/cycle_section_dialogs.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IntercourseAnalysis extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<CycleProvider>(context);
    final intercourseProvider = Provider.of<IntercourseProvider>(context);

    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text('Analysis', style: TextStyle(color: Colors.black)),
          leading: CircleAvatar(
            backgroundColor: Color(0xffFFC4E8),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                IntercourseDialogs.showHideOptionDialog(
                  context,
                  Color(0xFFEB1D98),
                );
              },
              icon: Icon(Icons.remove_red_eye, color: Colors.black),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Frequency Stats Section
              if (intercourseProvider.isSectionVisible('Frequency Statistics'))
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Frequency Stats",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    _buildChart( intercourseProvider),
                    Divider(height: 30),
                  ],
                ),

              // Intercourse Activity Section
              if (intercourseProvider.isSectionVisible('Intercourse Activity'))
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Intercourse Activity",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    _buildActivityStats(intercourseProvider),
                    Divider(height: 30),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          IntercourseDialogs.showHideOptionDialog(
                  context,
                  Color(0xFFEB1D98),
                );
                          },
                        child: Text("Show / Hide",
                            style: TextStyle(color: Colors.blue)),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
  // Widget _buildChart(BuildContext context, IntercourseProvider intercourseProvider, CycleProvider cycleProvider) {
  //   int periodDaysLength = cycleProvider.periodDays.length;
  //
  //   // Create an array to store the chances for each day
  //   List<String> chances = List.generate(periodDaysLength, (index) {
  //     DateTime day = cycleProvider.periodDays[index];
  //
  //     // Calculate pregnancy chance for this day using the intercourse data
  //     double pregnancyChance = intercourseProvider.calculatePregnancyChance(cycleProvider, day);
  //
  //     // Classify the chance into low, medium, or high
  //     if (pregnancyChance >= 60.0) {
  //       return 'High'; // High chance
  //     } else if (pregnancyChance >= 30.0) {
  //       return 'Medium'; // Medium chance
  //     } else {
  //       return 'Low'; // Low chance
  //     }
  //   });
  //
  //   // Now that we have the dynamic values for each day, let's display the chart
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Text("Chances of Getting Pregnant"),
  //         Row(
  //           children: [
  //             Text('LOW', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //             ...List.generate(periodDaysLength, (index) {
  //               return Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 4.0),
  //                 child: chances[index] == 'Low'
  //                     ? Icon(Icons.circle, color: Colors.red) // Example visual indicator for low chance
  //                     : Container(),
  //               );
  //             }),
  //           ],
  //         ),
  //         SizedBox(height: 5),
  //         Row(
  //           children: [
  //             Text('MEDIUM', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //             ...List.generate(periodDaysLength, (index) {
  //               return Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 4.0),
  //                 child: chances[index] == 'Medium'
  //                     ? Icon(Icons.circle, color: Colors.orange) // Example visual indicator for medium chance
  //                     : Container(),
  //               );
  //             }),
  //           ],
  //         ),
  //         SizedBox(height: 5),
  //         Row(
  //           children: [
  //             Text('HIGH', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //             ...List.generate(periodDaysLength, (index) {
  //               return Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 4.0),
  //                 child: chances[index] == 'High'
  //                     ? Icon(Icons.circle, color: Colors.green) // Example visual indicator for high chance
  //                     : Container(),
  //               );
  //             }),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
  // Chart widget with dynamic values
  Widget _buildChart(IntercourseProvider provider) {
    // Calculate dynamic probabilities or values for Low, Medium, and High columns
    final lowValues = _calculateDynamicValues(provider, "low");
    final mediumValues = _calculateDynamicValues(provider, "medium");
    final highValues = _calculateDynamicValues(provider, "high");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row with labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Orgasm Selection', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Condom Option', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Cycle Data', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Times Clicked', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Divider(height: 30),

        // Data Rows for Low, Medium, and High
        _buildDataRow('Low', lowValues),
        _buildDataRow('Medium', mediumValues),
        _buildDataRow('High', highValues),
      ],
    );
  }

  // Method to calculate dynamic values based on the provider and chart level (low/medium/high)
  List<String> _calculateDynamicValues(IntercourseProvider provider, String level) {
    // You can apply different logic for each level (low, medium, high) based on the data.
    // Example logic (you can adjust based on your needs):

    double orgasmSelection = provider.femaleOrgasm == 'Happened' ? 1 : 0;
    double condomOption = provider.condomOption == 'Protected' ? 1 : 0;
    double cycleData = 0.5;  // Assuming cycle data is a value between 0 and 1
    int timesClicked = provider.times;

    // Logic to calculate values based on levels
    double factor = (level == "low") ? 0.5 : (level == "medium") ? 1 : 1.5;

    // Example calculation
    double orgasmValue = orgasmSelection * factor;
    double condomValue = condomOption * factor;
    double cycleValue = cycleData * factor;
    double timesClickedValue = (timesClicked / 10) * factor;

    // Return values as strings to be displayed
    return [
      orgasmValue.toStringAsFixed(2),
      condomValue.toStringAsFixed(2),
      cycleValue.toStringAsFixed(2),
      timesClickedValue.toStringAsFixed(2),
    ];
  }

  // Method to build a single data row (Low, Medium, High)
  Widget _buildDataRow(String rowLabel, List<String> values) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(rowLabel, style: TextStyle(fontWeight: FontWeight.bold)),
        for (var value in values) _buildCircle(value),
      ],
    );
  }

  // Method to display the circles (Red or Green) based on the value
  Widget _buildCircle(String value) {
    double val = double.tryParse(value) ?? 0;

    // You can adjust color based on value thresholds
    Color circleColor = (val > 0.7) ? Colors.green : (val > 0.3) ? Colors.yellow : Colors.red;

    return CircleAvatar(
      radius: 20,
      backgroundColor: circleColor,
      child: Text(
        value,
        style: TextStyle(color: Colors.white),
      ),
    );
  }


  // Widget _buildChart(BuildContext context, IntercourseProvider intercourseProvider, CycleProvider cycleProvider) {
  //   int periodDaysLength = cycleProvider.periodDays.length;
  //
  //   // Create chances array based on both period and intercourse data
  //   List<String> chances = List.generate(periodDaysLength, (index) {
  //     DateTime day = cycleProvider.periodDays[index];
  //     String pregnancyChance = cycleProvider.getPregnancyChance(index);
  //
  //     // Check if intercourse happened during the fertile window (if necessary)
  //     bool isIntercourseDuringFertileWindow = intercourseProvider.didIntercourseHappenDuringFertileWindow(context);
  //
  //     // Modify chance logic to match both period and intercourse info
  //     if (isIntercourseDuringFertileWindow && pregnancyChance == "High Chance of Pregnancy") {
  //       return 'High';
  //     } else if (pregnancyChance == "Medium Chance of Pregnancy") {
  //       return 'Medium';
  //     } else {
  //       return 'Low';
  //     }
  //   });
  //
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Text("Chances of Getting Pregnant"),
  //         Row(
  //           children: [
  //             Text('LOW', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //             ...List.generate(periodDaysLength, (index) {
  //               return Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 4.0),
  //                 child: Checkbox(
  //                   value: chances[index] == 'Low',
  //                   onChanged: (value) {},
  //                 ),
  //               );
  //             }),
  //           ],
  //         ),
  //         SizedBox(height: 5),
  //         Row(
  //           children: [
  //             Text('MEDIUM', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //             ...List.generate(periodDaysLength, (index) {
  //               return Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 4.0),
  //                 child: Checkbox(
  //                   value: chances[index] == 'Medium',
  //                   onChanged: (value) {},
  //                 ),
  //               );
  //             }),
  //           ],
  //         ),
  //         SizedBox(height: 5),
  //         Row(
  //           children: [
  //             Text('HIGH', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //             ...List.generate(periodDaysLength, (index) {
  //               return Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 4.0),
  //                 child: Checkbox(
  //                   value: chances[index] == 'High',
  //                   onChanged: (value) {},
  //                 ),
  //               );
  //             }),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }



  Widget _buildActivityStats(IntercourseProvider intercourseProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ActivityColumn(
          label: "${intercourseProvider.times}x",
          description: "Intercourse",
        ),
        ActivityColumn(
          label:
              "${intercourseProvider.femaleOrgasm == 'Unprotected' ? '0%' : '100%'}",
          description: "Female Orgasm",
        ),
        ActivityColumn(
          label: intercourseProvider.condomOption == 'Protected' ? "1x" : "0x",
          description: "Protected",
        ),
        ActivityColumn(
          label:
              intercourseProvider.condomOption == 'Unprotected' ? "1x" : "0x",
          description: "Unprotected",
        ),
      ],
    );
  }
}

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

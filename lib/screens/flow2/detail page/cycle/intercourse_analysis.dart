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
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Frequency Stats Section
              if (intercourseProvider.isSectionVisible('Intercourse Chart'))
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Frequency Stats",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    _buildChart(intercourseProvider, cycleProvider.cycleLength,
                        cycleProvider.cycleDay, cycleProvider.periodLength),
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        child: Text("Show / Hide", style: TextStyle(color: Colors.blue)),
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
  Color _getColorForValue(double value) {
    if (value >= 0.7) return Colors.green; // High values
    if (value >= 0.4) return Colors.yellow; // Medium values
    return Colors.red; // Low values
  }
  List<String> _calculateDynamicValues(IntercourseProvider provider, String level, int cycleLength, int currentCycleDay, int periodLength) {
    double orgasmSelection = provider.femaleOrgasm == 'Happened' ? 1 : 0;
    double condomOption = provider.condomOption == 'Protected' ? 0.2 : 1.0; // Protection lowers risk significantly
    double cyclePhaseFactor = _getCyclePhaseFactor(cycleLength, currentCycleDay, periodLength);
    int timesClicked = provider.times;

    double factor = (level == "low") ? 0.5 : (level == "medium") ? 1.0 : 1.5;

    double orgasmValue = orgasmSelection * factor;
    double condomValue = condomOption * factor;
    double cycleValue = cyclePhaseFactor * factor;
    double timesClickedValue = (timesClicked * 0.1) * factor; // Normalize frequency impact

    return [
      orgasmValue.toStringAsFixed(2),
      condomValue.toStringAsFixed(2),
      cycleValue.toStringAsFixed(2),
      timesClickedValue.toStringAsFixed(2),
    ];
  }

  double _getCyclePhaseFactor(int cycleLength, int currentCycleDay, int periodLength) {
    int ovulationStart = (cycleLength * 0.14).round() - 2; // Allow for variability
    int ovulationEnd = ovulationStart + 4;

    if (currentCycleDay <= periodLength) return 0.2; // Low during period
    if (currentCycleDay == ovulationStart - 1) return 1.2; // High just before ovulation
    if (currentCycleDay >= ovulationStart && currentCycleDay <= ovulationEnd) return 1.0; // High during fertile window
    if (currentCycleDay > periodLength && currentCycleDay < ovulationStart) return 0.6; // Medium approaching fertile window
    return 0.3; // Low after ovulation
  }

  Widget _buildChart(IntercourseProvider provider, int cycleLength, int currentCycleDay, int periodLength) {
    final lowValues = _calculateDynamicValues(provider, "low", cycleLength, currentCycleDay, periodLength);
    final mediumValues = _calculateDynamicValues(provider, "medium", cycleLength, currentCycleDay, periodLength);
    final highValues = _calculateDynamicValues(provider, "high", cycleLength, currentCycleDay, periodLength);

    // Define the number of columns
    const int numberOfColumns = 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          border: TableBorder.all(color: Colors.black), // Add border to the entire table
          children: [
            TableRow(
              children: [
                _buildHeaderCell('Chances'),

                _buildHeaderCell('Orgasm Selection'),
                _buildHeaderCell('Condom Option'),
                _buildHeaderCell('Cycle Phase'),
                _buildHeaderCell('Frequency'),
              ],
            ),
            _buildDataRow('Low', lowValues, numberOfColumns),
            _buildDataRow('Medium', mediumValues, numberOfColumns),
            _buildDataRow('High', highValues, numberOfColumns),
          ],
        ),
      ],
    );
  }

  TableRow _buildDataRow(String rowLabel, List<String> values, int numberOfColumns) {
    List<Widget> cells = [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(rowLabel, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    ];

    // Add values to the cells
    for (var value in values) {
      cells.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: _getColorForValue(double.parse(value)),
            child: Text(
              value,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }

    // Fill the remaining cells with empty containers if necessary
    while (cells.length < numberOfColumns + 1) { // +1 for the row label
      cells.add(SizedBox()); // Add an empty widget to fill the space
    }

    return TableRow(children: cells); // Return a TableRow
  }

  Widget _buildHeaderCell(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
  // Ensure the chart section is toggleable
  Widget _buildActivityStats(IntercourseProvider intercourseProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ActivityColumn(
          label: "${intercourseProvider.times}x",
          description: "Intercourse",
        ),
        ActivityColumn(
          label: "${intercourseProvider.femaleOrgasm == 'Unprotected' ? '0%' : '100%'}",
          description: "Female Orgasm",
        ),
        ActivityColumn(
          label: intercourseProvider.condomOption == 'Protected' ? "1x" : "0x",
          description: "Protected",
        ),
        ActivityColumn(
          label: intercourseProvider.condomOption == 'Unprotected' ? "1x" : "0x",
          description: "Unprotected",
        ),
      ],
    );
  }
}



class IntercourxseAnalysis extends StatelessWidget {
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
                    _buildChart(intercourseProvider, cycleProvider.cycleLength,
                        cycleProvider.cycleDay, cycleProvider.periodLength),
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
  Widget _buildChart(IntercourseProvider provider, int cycleLength, int currentCycleDay, int periodLength) {
    final lowValues = _calculateDynamicValues(provider, "low", cycleLength, currentCycleDay, periodLength);
    final mediumValues = _calculateDynamicValues(provider, "medium", cycleLength, currentCycleDay, periodLength);
    final highValues = _calculateDynamicValues(provider, "high", cycleLength, currentCycleDay, periodLength);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Orgasm Selection', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Condom Option', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Cycle Phase', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Frequency', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Divider(height: 30),
        _buildDataRow('Low', lowValues),
        _buildDataRow('Medium', mediumValues),
        _buildDataRow('High', highValues),
      ],
    );
  }

  List<String> _calculateDynamicValues(IntercourseProvider provider, String level, int cycleLength, int currentCycleDay, int periodLength) {
    double orgasmSelection = provider.femaleOrgasm == 'Happened' ? 1 : 0;
    double condomOption = provider.condomOption == 'Protected' ? 0.2 : 1.0; // Protection lowers risk significantly
    double cyclePhaseFactor = _getCyclePhaseFactor(cycleLength, currentCycleDay, periodLength);
    int timesClicked = provider.times;

    double factor = (level == "low") ? 0.5 : (level == "medium") ? 1.0 : 1.5;

    double orgasmValue = orgasmSelection * factor;
    double condomValue = condomOption * factor;
    double cycleValue = cyclePhaseFactor * factor;
    double timesClickedValue = (timesClicked * 0.1) * factor; // Normalize frequency impact

    return [
      orgasmValue.toStringAsFixed(2),
      condomValue.toStringAsFixed(2),
      cycleValue.toStringAsFixed(2),
      timesClickedValue.toStringAsFixed(2),
    ];
  }

  double _getCyclePhaseFactor(int cycleLength, int currentCycleDay, int periodLength) {
    int ovulationStart = (cycleLength * 0.14).round() - 2; // Allow for variability
    int ovulationEnd = ovulationStart + 4;

    if (currentCycleDay <= periodLength) return 0.2; // Low during period
    if (currentCycleDay == ovulationStart - 1) return 1.2; // High just before ovulation
    if (currentCycleDay >= ovulationStart && currentCycleDay <= ovulationEnd) return 1.0; // High during fertile window
    if (currentCycleDay > periodLength && currentCycleDay < ovulationStart) return 0.6; // Medium approaching fertile window
    return 0.3; // Low after ovulation
  }

  Widget _buildDataRow(String rowLabel, List<String> values) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(rowLabel, style: TextStyle(fontWeight: FontWeight.bold)),
        for (var value in values)
          CircleAvatar(
            radius: 20,
            backgroundColor: _getColorForValue(double.parse(value)),
            child: Text(
              value,
              style: TextStyle(color: Colors.white),
            ),
          ),
      ],
    );
  }

  Color _getColorForValue(double value) {
    if (value >= 0.7) return Colors.green; // High values
    if (value >= 0.4) return Colors.yellow; // Medium values
    return Colors.red; // Low values
  }

  // Widget _buildChart(IntercourseProvider provider) {
  //   // Calculate dynamic probabilities or values for Low, Medium, and High columns
  //   final lowValues = _calculateDynamicValues(provider, "low");
  //   final mediumValues = _calculateDynamicValues(provider, "medium");
  //   final highValues = _calculateDynamicValues(provider, "high");
  //
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       // Header Row with labels
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
  //         children: [
  //           Text('Orgasm Selection', style: TextStyle(fontWeight: FontWeight.bold)),
  //           Text('Condom Option', style: TextStyle(fontWeight: FontWeight.bold)),
  //           Text('Cycle Data', style: TextStyle(fontWeight: FontWeight.bold)),
  //           Text('Times Clicked', style: TextStyle(fontWeight: FontWeight.bold)),
  //         ],
  //       ),
  //       Divider(height: 30),
  //
  //       // Data Rows for Low, Medium, and High
  //       _buildDataRow('Low', lowValues),
  //       _buildDataRow('Medium', mediumValues),
  //       _buildDataRow('High', highValues),
  //     ],
  //   );
  // }
  //
  // List<String> _calculateDynamicValues(IntercourseProvider provider, String level) {
  //   // Use similar logic as in the pregnancy chance calculation to determine chart values
  //   double orgasmSelection = provider.femaleOrgasm == 'Happened' ? 1 : 0;
  //   double condomOption = provider.condomOption == 'Protected' ? 1 : 0;
  //   double cycleData = 0.5;  // Assuming cycle data is a value between 0 and 1
  //   int timesClicked = provider.times;
  //
  //   double factor = (level == "low") ? 0.5 : (level == "medium") ? 1 : 1.5;
  //
  //   double orgasmValue = orgasmSelection * factor;
  //   double condomValue = condomOption * factor;
  //   double cycleValue = cycleData * factor;
  //   double timesClickedValue = (timesClicked / 10) * factor;
  //
  //   return [
  //     orgasmValue.toStringAsFixed(2),
  //     condomValue.toStringAsFixed(2),
  //     cycleValue.toStringAsFixed(2),
  //     timesClickedValue.toStringAsFixed(2),
  //   ];
  // }



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

import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/provider/intercourse_provider.dart';
import 'package:calender_app/screens/flow2/detail%20page/cycle/cycle_section_dialogs.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//
// class IntercourseAnalysis extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final cycleProvider = Provider.of<CycleProvider>(context);
//     final intercourseProvider = Provider.of<IntercourseProvider>(context);
//
//     return bgContainer(
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           centerTitle: true,
//           title: Text('Analysis', style: TextStyle(color: Colors.black)),
//           leading: CircleAvatar(
//             backgroundColor: Color(0xffFFC4E8),
//             child: IconButton(
//               icon: Icon(Icons.arrow_back, color: Colors.black),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ),
//           actions: [
//             IconButton(
//               onPressed: () {
//                 IntercourseDialogs.showHideOptionDialog(
//                   context,
//                   Color(0xFFEB1D98),
//                 );
//               },
//               icon: Icon(Icons.remove_red_eye, color: Colors.black),
//             ),
//           ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Frequency Stats Section
//               Text("Frequency Stats", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               SizedBox(height: 10),
//               _buildChart(context, intercourseProvider, cycleProvider),
//               Divider(height: 30),
//
//               // Intercourse Activity Section
//               Text("Intercourse Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               _buildActivityStats(intercourseProvider),
//               // Show/Hide Button
//               Center(
//                 child: TextButton(
//                   onPressed: () {
//                     // Toggle visibility logic here
//                   },
//                   child: Text("Show / Hide", style: TextStyle(color: Colors.blue)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildChart(BuildContext context, IntercourseProvider intercourseProvider, CycleProvider cycleProvider) {
//     // Check if periodDays has at least 5 items, otherwise handle it appropriately
//     int periodDaysLength = cycleProvider.periodDays.length;
//
//     // If there are fewer than 5 days, limit the chances array to the available days
//     List<String> chances = List.generate(periodDaysLength, (index) {
//       DateTime day = cycleProvider.periodDays[index];  // Get day from cycle data
//       String pregnancyChance = cycleProvider.getPregnancyChance(index); // Get pregnancy chance for that day
//
//       // Check if intercourse happened during the fertile window (if necessary)
//       bool isIntercourseDuringFertileWindow = intercourseProvider.didIntercourseHappenDuringFertileWindow(context);
//
//       // You can customize the logic based on your requirements
//       if (isIntercourseDuringFertileWindow && pregnancyChance == "High Chance of Pregnancy") {
//         return 'High';  // Mark checkbox if intercourse happened during fertile window
//       } else if (pregnancyChance == "Medium Chance of Pregnancy") {
//         return 'Medium';
//       } else {
//         return 'Low'; // Default to low chance
//       }
//     });
//
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Column( mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text("Chances of Getting Pregnant"),
//           // LOW Chance row with checkboxes
//           Row(
//             children: [
//               Text('LOW', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               // Generate checkboxes within the same Row
//               ...List.generate(periodDaysLength, (index) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                   child: Checkbox(
//                     value: chances[index] == 'Low', // Mark the checkbox based on the chance
//                     onChanged: (value) {
//                       // Handle change here if needed
//                     },
//                   ),
//                 );
//               }),
//             ],
//           ),
//           SizedBox(height: 5),
//
//           // MEDIUM Chance row with checkboxes
//           Row(
//             children: [
//               Text('MEDIUM', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               // Generate checkboxes within the same Row
//               ...List.generate(periodDaysLength, (index) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                   child: Checkbox(
//                     value: chances[index] == 'Medium', // Mark the checkbox based on the chance
//                     onChanged: (value) {
//                       // Handle change here if needed
//                     },
//                   ),
//                 );
//               }),
//             ],
//           ),
//           SizedBox(height: 5),
//
//           // HIGH Chance row with checkboxes
//           Row(
//             children: [
//               Text('HIGH', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               // Generate checkboxes within the same Row
//               ...List.generate(periodDaysLength, (index) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                   child: Checkbox(
//                     value: chances[index] == 'High', // Mark the checkbox based on the chance
//                     onChanged: (value) {
//                       // Handle change here if needed
//                     },
//                   ),
//                 );
//               }),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActivityStats(IntercourseProvider intercourseProvider) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         ActivityColumn(
//           label: "${intercourseProvider.times}x",
//           description: "Intercourse",
//         ),
//         ActivityColumn(
//           label: "${intercourseProvider.femaleOrgasm == 'Unprotected' ? '0%' : '100%'}",
//           description: "Female Orgasm",
//         ),
//         ActivityColumn(
//           label: intercourseProvider.condomOption == 'Protected' ? "1x" : "0x",
//           description: "Protected",
//         ),
//         ActivityColumn(
//           label: intercourseProvider.condomOption == 'Unprotected' ? "1x" : "0x",
//           description: "Unprotected",
//         ),
//       ],
//     );
//   }
// }
//
// class ActivityColumn extends StatelessWidget {
//   final String label;
//   final String description;
//
//   const ActivityColumn({required this.label, required this.description});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 4),
//         Text(description),
//       ],
//     );
//   }
// }
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
                    _buildChart(context, intercourseProvider, cycleProvider),
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

  Widget _buildChart(BuildContext context,
      IntercourseProvider intercourseProvider, CycleProvider cycleProvider) {
    // Check if periodDays has at least 5 items, otherwise handle it appropriately
    int periodDaysLength = cycleProvider.periodDays.length;

    // If there are fewer than 5 days, limit the chances array to the available days
    List<String> chances = List.generate(periodDaysLength, (index) {
      DateTime day = cycleProvider.periodDays[index]; // Get day from cycle data
      String pregnancyChance = cycleProvider
          .getPregnancyChance(index); // Get pregnancy chance for that day

      // Check if intercourse happened during the fertile window (if necessary)
      bool isIntercourseDuringFertileWindow =
          intercourseProvider.didIntercourseHappenDuringFertileWindow(context);

      // You can customize the logic based on your requirements
      if (isIntercourseDuringFertileWindow &&
          pregnancyChance == "High Chance of Pregnancy") {
        return 'High'; // Mark checkbox if intercourse happened during fertile window
      } else if (pregnancyChance == "Medium Chance of Pregnancy") {
        return 'Medium';
      } else {
        return 'Low'; // Default to low chance
      }
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Chances of Getting Pregnant"),
          // LOW Chance row with checkboxes
          Row(
            children: [
              Text('LOW',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              // Generate checkboxes within the same Row
              ...List.generate(periodDaysLength, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Checkbox(
                    value: chances[index] ==
                        'Low', // Mark the checkbox based on the chance
                    onChanged: (value) {
                      // Handle change here if needed
                    },
                  ),
                );
              }),
            ],
          ),
          SizedBox(height: 5),

          // MEDIUM Chance row with checkboxes
          Row(
            children: [
              Text('MEDIUM',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              // Generate checkboxes within the same Row
              ...List.generate(periodDaysLength, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Checkbox(
                    value: chances[index] ==
                        'Medium', // Mark the checkbox based on the chance
                    onChanged: (value) {
                      // Handle change here if needed
                    },
                  ),
                );
              }),
            ],
          ),
          SizedBox(height: 5),

          // HIGH Chance row with checkboxes
          Row(
            children: [
              Text('HIGH',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              // Generate checkboxes within the same Row
              ...List.generate(periodDaysLength, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Checkbox(
                    value: chances[index] ==
                        'High', // Mark the checkbox based on the chance
                    onChanged: (value) {
                      // Handle change here if needed
                    },
                  ),
                );
              }),
            ],
          ),
        ],
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

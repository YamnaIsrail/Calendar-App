import 'package:calender_app/provider/preg_provider.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';

import 'partner_mode_setting.dart';

// class PartnerModeToday extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(onPressed: (){
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => PartnerModeSetting()),
//           );
//         },
//             icon: Icon(Icons.menu)),
//
//         title: Text('Partner Mode'),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/bg.jpg'), // Use AssetImage for local images
//             fit: BoxFit.cover, // Adjust the fit as needed (cover, contain, fill, etc.)
//           ),
//         ),
//
//         child: Column(
//           children: [
//             Expanded(
//               child: Stack(
//                 children: [
//                   Image.asset("assets/cal.png"),
//                   Positioned(
//                     top: 130, // Adjust this value to position vertically
//                     left: 0,
//                     right: 0,
//                     child: Column(
//                       children: [
//                         Text(
//                           "13 Days Left",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(fontSize: 20, color: Colors.black), // Style as needed
//                         ),
//                         SizedBox(height: 5), // Add space between texts
//                         Text(
//                           "Next periods will start on",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(fontSize: 16, color: Colors.black), // Style as needed
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     children: [
//
//                       // Today - Cycle Day 11 Section
//                       Container(
//                         padding: const EdgeInsets.all(16.0),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.3),
//                               spreadRadius: 2,
//                               blurRadius: 5,
//                               offset: Offset(0, 3),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Today - Cycle Day 11',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             SizedBox(height: 8),
//                             Text(
//                               'HIGH - Chance of getting periods',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.red,
//                               ),
//                             ),
//                             SizedBox(height: 16),
//
//                             // Progress Bar
//                             Row(
//                               children: [
//                                 Text("Oct 3"),
//                                 Expanded(
//                                   child: LinearProgressIndicator(
//                                     value: 0.55, // Adjust this value as needed
//                                     color: Colors.pink,
//                                     backgroundColor: Colors.grey[300],
//                                   ),
//                                 ),
//                                 Text("Today"),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
// }
//
// extension on DateTime {
//   String toShortDateString() {
//     return "${this.day}/${this.month}/${this.year}";
//   }}

import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PregnancyStatusScreen extends StatelessWidget {
  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final pregnancyProvider = Provider.of<PregnancyProvider>(context);

    final lastMenstrualPeriod = pregnancyProvider.lastMenstrualPeriod;
    final dueDate = pregnancyProvider.dueDate;
    final currentWeek = pregnancyProvider.getCurrentWeek();
    final daysUntilDueDate = pregnancyProvider.getDaysUntilDueDate();

    bool isInfoAvailable = lastMenstrualPeriod != DateTime.now() && dueDate != DateTime.now().add(Duration(days: 280));

    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Pregnancy Status"),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PartnerModeSetting()),
              );
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: isInfoAvailable
              ? Column(
            children: [
              Container(
                height: 280,
                width: 280,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/cal.png"),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      daysUntilDueDate < 0
                          ? "Baby is ${daysUntilDueDate.abs()} days overdue!"
                          : "$daysUntilDueDate Days Left",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    SizedBox(height: 5),
                    Text(
                      daysUntilDueDate < 0
                          ? "Due date was\n${formatDate(dueDate)}"
                          : "Due date is\n${formatDate(dueDate)}",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Pregnancy Details",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text("Last Menstrual Period: ${formatDate(lastMenstrualPeriod)}"),
                                SizedBox(height: 8),
                                Text("Current Week: $currentWeek"),
                                SizedBox(height: 8),
                                Text("Due Date: ${formatDate(dueDate)}"),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () async {
                                // Show Date Picker to edit Last Menstrual Period and Due Date
                                DateTime? newLMP = await showDatePicker(
                                  context: context,
                                  initialDate: lastMenstrualPeriod,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                );
                                if (newLMP != null) {
                                  DateTime? newDueDate = await showDatePicker(
                                    context: context,
                                    initialDate: dueDate,
                                    firstDate: newLMP.add(Duration(days: 1)),
                                    lastDate: DateTime(2101),
                                  );
                                  if (newDueDate != null) {
                                    pregnancyProvider.updatePregnancyInfo(newLMP, newDueDate);
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      buildCycleInfoCard(
                        icon: Icons.baby_changing_station,
                        title: 'Week $currentWeek Progress',
                        subtitle: daysUntilDueDate < 0
                            ? 'Your baby is overdue. Contact your doctor!'
                            : 'Your pregnancy is progressing smoothly.',
                        progressLabelStart: "Week 1",
                        progressLabelEnd: "Week 40",
                        progressValue: currentWeek / 40,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
              : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Pregnancy information is missing.",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to a page to add/update pregnancy information
                  },
                  child: Text("Add Pregnancy Info"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCycleInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String progressLabelStart,
    required String progressLabelEnd,
    required double progressValue,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.blueGrey,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text(progressLabelStart),
              Expanded(
                child: LinearProgressIndicator(
                  value: progressValue,
                  color: Colors.blue,
                  backgroundColor: Colors.grey[300],
                ),
              ),
              Text(progressLabelEnd),
            ],
          ),
        ],
      ),
    );
  }
}

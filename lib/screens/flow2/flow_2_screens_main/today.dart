import 'package:calender_app/hive/cycle_model.dart';
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/provider/intercourse_provider.dart';
import 'package:calender_app/provider/preg_provider.dart';
import 'package:calender_app/screens/flow2/detail%20page/today_cycle_phase/period_phase.dart';
import 'package:calender_app/screens/settings/settings_page.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/cycle_info_card.dart';
import 'package:calender_app/widgets/cycle_phase_card.dart';
import 'package:calender_app/widgets/flow2_appbar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

class CycleStatusScreen extends StatelessWidget {
  final String? userImageUrl;

  CycleStatusScreen({this.userImageUrl});

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          pageTitle: "",
          onCancel: () {

          },
          onBack: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          },
        ),
        body: Consumer3<CycleProvider, PregnancyModeProvider, IntercourseProvider>(
          builder: (context, cycleProvider, pregnancyModeProvider,intercourseProvider, child) {
            final daysUntilNextPeriod = cycleProvider.getDaysUntilNextPeriod();
            final nextPeriodDate = cycleProvider.getNextPeriodDate();
            final currentCycleDay = cycleProvider.daysElapsed + 1;
            final lastPeriodDate = cycleProvider.lastPeriodStart;
            final periodLength = cycleProvider.periodLength;
            final cycleLength = cycleProvider.cycleLength;


            String getFormattedDueDate(DateTime? dueDate) {
              if (dueDate == null) return "No due date";
              return DateFormat('yyyy-MM-dd').format(dueDate);
            }
            // Determine if in pregnancy mode
            bool isPregnancyMode = pregnancyModeProvider.isPregnancyMode;

            return Column(
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
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Text(
                          isPregnancyMode
                              ? pregnancyModeProvider.gestationWeeks != null
                              ? "Expected date\n ${getFormattedDueDate(pregnancyModeProvider.dueDate)}"
                              : "Pregnancy Mode Active"
                              : daysUntilNextPeriod < 0
                              ? "${daysUntilNextPeriod.abs()} Day(s) Late"
                              : "$daysUntilNextPeriod Day(s) Left",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        SizedBox(height: 5),
                        Text(
                          isPregnancyMode
                              ? pregnancyModeProvider.gestationStart != null
                              ? " ${pregnancyModeProvider.gestationWeeks !}Weeks ${pregnancyModeProvider.gestationDays !}Days"
                              : ""
                              : daysUntilNextPeriod < 0
                              ? "Your period was expected\non ${formatDate(nextPeriodDate)}."
                              : "Next period will start\non ${formatDate(nextPeriodDate)}",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Cycle Phase Card Section
                          Container(
                            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16),
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
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Cycle Phase",
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.arrow_forward_ios_rounded),
                                      onPressed: () {
                                        try {
                                          final box = Hive.box<CycleData>('cycledata');
                                          print("Stored Data:");
                                          print("Last Period Start: ${box.get('lastPeriodStart')}");
                                          print("Cycle Length: ${box.get('cycleLength')}");
                                          print("Period Length: ${box.get('periodLength')}");

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PeriodPhaseScreen(),
                                            ),
                                          );
                                        } catch (e) {
                                          print("Error: $e");
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                // SizedBox(
                                //   height: 120,
                                //   child: ListView(
                                //     scrollDirection: Axis.horizontal,
                                //     children: [
                                //       CyclePhaseCard(
                                //         icon: Icons.favorite,
                                //         color: Colors.red[100]!,
                                //         phase: isPregnancyMode
                                //             ? "First Trimester"
                                //             : "Menstrual Phase",
                                //         date: isPregnancyMode
                                //             ? pregnancyModeProvider.gestationStart != null
                                //             ? "Pregnancy start ${formatDate(pregnancyModeProvider.gestationStart!)}"
                                //             : ""
                                //             : "Start Date: ${formatDate(cycleProvider.lastPeriodStart)}",
                                //       ),
                                //       CyclePhaseCard(
                                //         icon: Icons.fiber_manual_record,
                                //         color: Colors.green[100]!,
                                //         phase: isPregnancyMode
                                //             ? "Second Trimester"
                                //             : "Follicular Phase",
                                //         date: isPregnancyMode
                                //             ? pregnancyModeProvider.gestationStart != null
                                //             ? "Due soon"
                                //             : ""
                                //             : "Start Date: ${formatDate(cycleProvider.lastPeriodStart.add(Duration(days: cycleProvider.cycleLength - 14)))}",
                                //       ),
                                //       CyclePhaseCard(
                                //         icon: Icons.calendar_today,
                                //         color: Colors.blue[100]!,
                                //         phase: "Fertility Window",
                                //         date: "From: ${formatDate(cycleProvider.getFertilityWindowStart())} To: ${formatDate(cycleProvider.getFertilityWindowEnd())}",
                                //       ),
                                //
                                //       CyclePhaseCard(
                                //         icon: Icons.egg,
                                //         color: Colors.orange[100]!,
                                //         phase: "Ovulation",
                                //         date: "Date: ${formatDate(cycleProvider.getOvulationDate())}",
                                //       ),
                                //
                                //       CyclePhaseCard(
                                //         icon: Icons.next_plan,
                                //         color: Colors.purple[100]!,
                                //         phase: "Next Period",
                                //         date: "Date: ${formatDate(cycleProvider.getNextPeriodDate())}",
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                SizedBox(
                                  height: 120,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      CyclePhaseCard(
                                        icon: Icons.favorite,
                                        color: Colors.red[100]!,
                                        phase: isPregnancyMode
                                            ? "First Trimester"
                                            : "Menstrual Phase",
                                        date: isPregnancyMode
                                            ? pregnancyModeProvider.gestationStart != null
                                            ? "Pregnancy start ${formatDate(pregnancyModeProvider.gestationStart!)}"
                                            : ""
                                            : "Start Date: ${formatDate(cycleProvider.lastPeriodStart)}",
                                      ),

                                      CyclePhaseCard(
                                        icon: Icons.fiber_manual_record,
                                        color: Colors.green[100]!,
                                        phase: isPregnancyMode
                                            ? "Second Trimester"
                                            : "Fertility Window", // This can be removed if not needed
                                        date: isPregnancyMode
                                            ? pregnancyModeProvider.gestationStart != null
                                            ? "Due soon" // You can also add the expected due date here
                                            : ""
                                            : "From: ${formatDate(cycleProvider.getFertilityWindowStart())} "
                                            "To: ${formatDate(cycleProvider.getFertilityWindowEnd())}",

                                        ),

                                      if (!isPregnancyMode)
                                        CyclePhaseCard(
                                        icon: Icons.egg,
                                        color: Colors.orange[100]!,
                                        phase: "Ovulation",
                                        date: "Date: ${formatDate(cycleProvider.getOvulationDate())}", // Added Ovulation card
                                      ),
                                      CyclePhaseCard(
                                        icon: Icons.next_plan,
                                        color: Colors.purple[100]!,
                                        phase: isPregnancyMode
                                            ? "Due Date"
                                            : "Next Period",
                                        date: isPregnancyMode
                                            ? pregnancyModeProvider.dueDate != null
                                            ? "Due Date: ${formatDate(pregnancyModeProvider.dueDate!)}" // Show expected due date
                                            : ""
                                            : "Date: ${formatDate(cycleProvider.getNextPeriodDate())}",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),

                          // Today's Cycle Status with pregnancy logic
                          buildCycleInfoCard(
                            icon: Icons.replay_5,
                            title: isPregnancyMode
                                ? "Pregnancy Progress"
                                : 'Today - Cycle Day $currentCycleDay',
                            subtitle: isPregnancyMode
                                ? "Track your pregnancy milestones"
                                :getpPregnancyChanceText(context,
                                lastPeriodDate,
                                periodLength,
                                currentCycleDay,
                                cycleLength,
                                intercourseProvider),
                            progressLabelStart: isPregnancyMode
                                ? pregnancyModeProvider.gestationStart != null
                                ? formatDate(pregnancyModeProvider.gestationStart!)
                                : ""
                                : formatDate(cycleProvider.lastPeriodStart),
                            progressLabelEnd: isPregnancyMode
                                ? pregnancyModeProvider.dueDate != null
                                ? formatDate(pregnancyModeProvider.dueDate!)
                                : ""
                                : formatDate(
                              cycleProvider.lastPeriodStart.add(
                                Duration(days: cycleProvider.periodLength),
                              ),
                            ),
                            progressValue: isPregnancyMode
                                ? (pregnancyModeProvider.gestationWeeks ?? 1) / 40.0
                                : currentCycleDay / cycleProvider.cycleLength,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// String getPregnancyChanceText(BuildContext context,lastPeriodDate,periodLength, int currentCycleDay, cycleLength, ) {
//
//   if (currentCycleDay <= periodLength) {
//     return 'Low chance of getting pregnancy (on period)';
//   }
//
//   // Calculate ovulation window (typically days 10-15, based on cycle length)
//   int ovulationStart = cycleLength ~/ 2 - 1;  // Ovulation starts around the middle of the cycle
//   int ovulationEnd = ovulationStart + 4;  // Ovulation lasts a few days
//
//   // Ovulation phase (days around ovulation)
//   if (currentCycleDay >= ovulationStart && currentCycleDay <= ovulationEnd) {
//     return 'High chance of getting pregnancy (ovulation phase)';
//   }
//
//   // Follicular phase (before ovulation)
//   else if (currentCycleDay >= periodLength + 1 && currentCycleDay < ovulationStart) {
//     return 'Medium chance of getting pregnancy (approaching ovulation)';
//   }
//
//   // Luteal phase (after ovulation)
//   else if (currentCycleDay > ovulationEnd && currentCycleDay <= cycleLength) {
//     return 'Low chance of getting pregnancy (luteal phase)';
//   }
//
//   // After the cycle ends (next cycle phase)
//   else {
//     return 'High chance of getting pregnancy';
//   }
// }

//Detailed explanation
String getPregnancyChanceText(
    BuildContext context,
    DateTime lastPeriodDate,
    int periodLength,
    int currentCycleDay,
    int cycleLength,
    IntercourseProvider intercourseProvider,
    ) {
  // Calculate ovulation window
  int ovulationStart = cycleLength ~/ 2 - 1;
  int ovulationEnd = ovulationStart + 4;

  // Determine the condom protection status
  bool isProtected = intercourseProvider.condomOption == 'Protected';
  int numberOfTimes = intercourseProvider.times;

  if (numberOfTimes == 0) {
    return 'No intercourse detected during this cycle. No chance of pregnancy.';
  }

  // Calculate pregnancy chances based on the combination of factors
  if (currentCycleDay <= periodLength) {
    return 'You are currently on your period. Low chance of pregnancy. Intercourse details: ${isProtected ? 'Protected' : 'Unprotected'}.';
  } else if (currentCycleDay >= ovulationStart && currentCycleDay <= ovulationEnd) {
    if (intercourseProvider.femaleOrgasm == 'Happened' && !isProtected) {
      return 'High chance of pregnancy: Fertile window with unprotected intercourse and orgasm detected.';
    }
    return 'You are in your fertile window. ${isProtected ? 'Low chance of pregnancy: Protected intercourse.' : 'High chance of pregnancy: Unprotected intercourse.'}';
  } else if (currentCycleDay >= periodLength + 1 && currentCycleDay < ovulationStart) {
    // Consider orgasm status in the approaching fertile window
    if (intercourseProvider.femaleOrgasm == 'Happened') {
      return 'Medium chance of pregnancy: Approaching fertile window with orgasm. ${isProtected ? 'Protected intercourse reduces chance.' : 'Unprotected intercourse increases chance.'}';
    } else {
      return 'Medium chance of pregnancy: Approaching fertile window without orgasm. ${isProtected ? 'Protected intercourse reduces chance.' : 'Unprotected intercourse increases chance.'}';
    }
  } else if (currentCycleDay > ovulationEnd && currentCycleDay <= cycleLength) {
    return 'Low chance of pregnancy: In the luteal phase. ${isProtected ? 'Protected intercourse reduces chance.' : 'Unprotected intercourse may still result in pregnancy.'}';
  } else {
    return 'Cycle has ended. Plan for your next cycle. Intercourse summary: ${numberOfTimes > 0 ? '$numberOfTimes times with ${isProtected ? 'protection' : 'no protection'}.' : 'No intercourse during this cycle.'}';
  }
}

//only text explanation
String gettPregnancyChanceText(
    BuildContext context,
    DateTime lastPeriodDate,
    int periodLength,
    int currentCycleDay,
    int cycleLength,
    IntercourseProvider intercourseProvider,
    ) {
  // Calculate ovulation window
  int ovulationStart = cycleLength ~/ 2 - 1;
  int ovulationEnd = ovulationStart + 4;

  // Determine the condom protection status
  bool isProtected = intercourseProvider.condomOption == 'Protected';
  int numberOfTimes = intercourseProvider.times;

  // No intercourse detected
  if (numberOfTimes == 0) {
    return 'No chance of pregnancy.';
  }

  // Current period check
  if (currentCycleDay <= periodLength) {
    return 'Low chance of pregnancy.';
  }

  // Fertile window check
  if (currentCycleDay >= ovulationStart && currentCycleDay <= ovulationEnd) {
    if (intercourseProvider.femaleOrgasm == 'Happened' && !isProtected) {
      return 'High chance of pregnancy.';
    }
    if (numberOfTimes > 1 && !isProtected) {
      return 'High chance of pregnancy.';
    }
    return isProtected ? 'Low chance of pregnancy.' : 'High chance of pregnancy.';
  }

  // Approaching fertile window
  if (currentCycleDay >= periodLength + 1 && currentCycleDay < ovulationStart) {
    return isProtected ? 'Low chance of pregnancy.' : 'Medium chance of pregnancy.';
  }

  // Luteal phase
  if (currentCycleDay > ovulationEnd && currentCycleDay <= cycleLength) {
    return isProtected ? 'Low chance of pregnancy.' : 'Medium chance of pregnancy.';
  }

  // Cycle has ended
  return 'No chance of pregnancy.';
}


//with percentage
String getpPregnancyChanceText(
    BuildContext context,
    DateTime lastPeriodDate,
    int periodLength,
    int currentCycleDay,
    int cycleLength,
    IntercourseProvider intercourseProvider,
    ) {
  // Calculate ovulation window
  int ovulationStart = cycleLength ~/ 2 - 1;
  int ovulationEnd = ovulationStart + 4;

  // Determine the condom protection status
  bool isProtected = intercourseProvider.condomOption == 'Protected';
  int numberOfTimes = intercourseProvider.times;

  double pregnancyChancePercentage = 0.0;
  String chanceText = '';

  // No intercourse detected
  if (numberOfTimes == 0) {
    return 'No chance of pregnancy (0%).';
  }

  // Current period check
  if (currentCycleDay <= periodLength) {
    pregnancyChancePercentage = 5.0; // Low chance
    chanceText = 'Low chance of pregnancy';
  }
  // Fertile window check
  else if (currentCycleDay >= ovulationStart && currentCycleDay <= ovulationEnd) {
    if (!isProtected) {
      if (intercourseProvider.femaleOrgasm == 'Happened') {
        pregnancyChancePercentage = 90.0; // High chance
        chanceText = 'High chance of pregnancy';
      } else {
        pregnancyChancePercentage = 70.0; // High chance without orgasm
        chanceText = 'High chance of pregnancy';
      }
    } else {
      // Protected intercourse
      pregnancyChancePercentage = 20.0; // Low chance
      chanceText = 'Low chance of pregnancy';
    }
  }
  // Approaching fertile window
  else if (currentCycleDay >= periodLength + 1 && currentCycleDay < ovulationStart) {
    if (isProtected) {
      pregnancyChancePercentage = 10.0; // Low chance
      chanceText = 'Low chance of pregnancy';
    } else {
      // Unprotected
      pregnancyChancePercentage = 20.0 + (numberOfTimes * 5.0); // Increase by 5% for each unprotected intercourse
      chanceText = 'Medium chance of pregnancy';
    }
  }
  // Luteal phase
  else if (currentCycleDay > ovulationEnd && currentCycleDay <= cycleLength) {
    if (isProtected) {
      pregnancyChancePercentage = 5.0; // Low chance
      chanceText = 'Low chance of pregnancy';
    } else {
      pregnancyChancePercentage = 30.0; // Medium chance
      chanceText = 'Medium chance of pregnancy';
    }
  }
  // Cycle has ended
  else {
    return 'No chance of pregnancy (0%).';
  }

  // Cap the percentage at 100%
  pregnancyChancePercentage = pregnancyChancePercentage.clamp(0.0, 100.0);

  return '$chanceText (${pregnancyChancePercentage.toStringAsFixed(1)}%).';
}
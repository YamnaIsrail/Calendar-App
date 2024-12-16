import 'package:calender_app/hive/cycle_model.dart';
import 'package:calender_app/provider/cycle_provider.dart';
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
          onCancel: () {},
          onBack: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          },
        ),
        body: Consumer2<CycleProvider, PregnancyModeProvider>(
          builder: (context, cycleProvider, pregnancyModeProvider, child) {
            final daysUntilNextPeriod = cycleProvider.getDaysUntilNextPeriod();
            final nextPeriodDate = cycleProvider.getNextPeriodDate();
            final currentCycleDay = cycleProvider.daysElapsed + 1;

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
                              ? "Next period was expected\non ${formatDate(nextPeriodDate)}."
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
                                            : "Follicular Phase",
                                        date: isPregnancyMode
                                            ? pregnancyModeProvider.gestationStart != null
                                            ? "Due soon"
                                            : ""
                                            : "Start Date: ${formatDate(cycleProvider.lastPeriodStart.add(Duration(days: cycleProvider.cycleLength - 14)))}",
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
                                : 'High chance of getting periods',
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

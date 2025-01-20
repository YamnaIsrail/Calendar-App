import 'package:calender_app/hive/cycle_model.dart';
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/provider/date_day_format.dart';
import 'package:calender_app/provider/intercourse_provider.dart';
import 'package:calender_app/provider/preg_provider.dart';
import 'package:calender_app/provider/showhide.dart';
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
import 'progress_arcs.dart';

class CycleStatusScreen extends StatelessWidget {
  final String? userImageUrl;

  CycleStatusScreen({this.userImageUrl});

  @override
  Widget build(BuildContext context) {
    final showHideProvider = context.watch<ShowHideProvider>();

    String formatDate(DateTime date) {
      String selectedFormat = context.watch<SettingsModel>().dateFormat;
      if (selectedFormat == "System Default") {
        return DateFormat.yMd().format(date); // Use system locale's default
      } else {
        return DateFormat(selectedFormat).format(date); // Use selected format
      }
    }

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
        body: Consumer3<CycleProvider, PregnancyModeProvider,
            IntercourseProvider>(
          builder: (context, cycleProvider, pregnancyModeProvider,
              intercourseProvider, child) {
            final daysUntilNextPeriod = cycleProvider.getDaysUntilNextPeriod();
            final nextPeriodDate = cycleProvider.getNextPeriodDate();
            final currentCycleDay = cycleProvider.daysElapsed + 1;
            final lastPeriodDate = cycleProvider.lastPeriodStart;
            final periodLength = cycleProvider.periodLength;
            final cycleLength = cycleProvider.cycleLength;
            final endDate = cycleProvider.lastPeriodStart.add(Duration(days:  periodLength - 1));;


            String getFormattedDueDate(DateTime? dueDate) {
              if (dueDate == null) return "No due date";
              return DateFormat(context.watch<SettingsModel>().dateFormat)
                  .format(dueDate);
            }

            // Determine if in pregnancy mode
            bool isPregnancyMode = pregnancyModeProvider.isPregnancyMode;

            return Column(
              children: [
                Stack(
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
                            if (pregnancyModeProvider.isPregnancyMode) ...[
                              // Pregnancy Mode Active
                              Text(
                                pregnancyModeProvider.gestationWeeks != null
                                    ? "Expected due date\n ${getFormattedDueDate(pregnancyModeProvider.dueDate)}"
                                    : "Pregnancy Mode Active",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                              SizedBox(height: 5),
                              if (pregnancyModeProvider.gestationStart != null) ...[
                                Text(
                                  "${pregnancyModeProvider.gestationWeeks!} Weeks ${pregnancyModeProvider.gestationDays!} Days",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12, color: Colors.black),
                                ),
                              ],
                            ] else ...[
                              // Not in Pregnancy Mode, show period-related information
                              if (currentCycleDay <= periodLength-1) ...[
                                // Show current cycle details
                                Text(
                                  "Periods", // Show the period end date
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 8, color: Colors.black),
                                ),
                                Text(
                                  "Day $currentCycleDay", // Show the period day
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                ),
                                SizedBox(height: 5),
                                // Show the period end date
                                Text(
                                  "Period will end on \n ${formatDate(endDate)}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12, color: Colors.black),
                                ),
                              ] else ...[
                                // Period is over, show future period details
                                Text(
                                  showHideProvider.visibilityMap['Future Period'] == true
                                      ? (daysUntilNextPeriod == 0
                                      ? "Today" // If the period is due today, show "Today"
                                      : (daysUntilNextPeriod < 0
                                      ? "${daysUntilNextPeriod.abs()} Day(s) Late"
                                      : "$daysUntilNextPeriod Day(s) Left"))
                                      : "Future Period\n is Disabled",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                ),
                                SizedBox(height: 5),
                                // Show next period details
                                Text(
                                  showHideProvider.visibilityMap['Future Period'] == true
                                      ? (daysUntilNextPeriod == 0
                                      ? "Period is expected to begin \n ${formatDate(nextPeriodDate)}"
                                      : (daysUntilNextPeriod < 0
                                      ? "Your period was expected\non ${formatDate(nextPeriodDate)}."
                                      : "Next period will start\non ${formatDate(nextPeriodDate)}"))
                                      : " ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12, color: Colors.black),
                                ),
                              ],
                            ],
                          ],
                        ),
                      )
                    ),
                    SizedBox(
                      height: 280,
                      width: 280,
                      child: CustomPaint(
                        painter: isPregnancyMode
                            ? PregnancyProgressPainter(
                          pregnancyProvider: pregnancyModeProvider,
                        )
                            : CycleProgressPainter(
                          cycleProvider: CycleProvider(),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Cycle Phase Card Section
                          Container(
                            padding: const EdgeInsets.only(
                                top: 16.0, bottom: 16.0, left: 16),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Cycle Phase",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(Icons.arrow_forward_ios_rounded),
                                      onPressed: () async {
                                        try {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PeriodPhaseScreen(),
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
                                            ? pregnancyModeProvider
                                                        .gestationStart !=
                                                    null
                                                ? "Pregnancy start ${formatDate(pregnancyModeProvider.gestationStart!)}"
                                                : ""
                                            : "Start Date: ${formatDate(cycleProvider.lastPeriodStart)}",
                                      ),
                                      CyclePhaseCard(
                                        icon: Icons.wb_sunny,
                                        color: Colors.green[100]!,
                                        phase: isPregnancyMode
                                            ? "Second Trimester"
                                            : "Fertility Window", // Always show the card
                                        date: isPregnancyMode
                                            ? pregnancyModeProvider
                                                        .gestationStart !=
                                                    null
                                                ? "Due soon" // You can also add the expected due date here
                                                : ""
                                            : showHideProvider.visibilityMap[
                                                        'Ovulation / Fertile'] ==
                                                    true
                                                ? "From: ${formatDate(cycleProvider.getFertilityWindowStart())} "
                                                : "  Disabled", // Show 'Disabled' when not visible
                                      ),
                                      if (!isPregnancyMode ||
                                          showHideProvider.visibilityMap[
                                                  'Ovulation / Fertile'] ==
                                              true)
                                        CyclePhaseCard(
                                          icon: Icons.egg,
                                          color: Colors.orange[100]!,
                                          phase: "Ovulation",
                                          date: showHideProvider.visibilityMap[
                                                      'Ovulation / Fertile'] ==
                                                  true
                                              ? "Date: ${formatDate(cycleProvider.getOvulationDate())}" // Ovulation card with date
                                              : "Disabled", // If not visible, show 'Disabled'
                                        ),
                                      CyclePhaseCard(
                                        icon: Icons.next_plan,
                                        color: Colors.purple[100]!,
                                        phase: isPregnancyMode
                                            ? "Due Date"
                                            : "Next Period",
                                        date: showHideProvider.visibilityMap[
                                                    'Future Period'] ==
                                                true
                                            ? (isPregnancyMode
                                                ? (pregnancyModeProvider
                                                            .dueDate !=
                                                        null
                                                    ? "Due Date: ${formatDate(pregnancyModeProvider.dueDate!)}"
                                                    : "")
                                                : "Date: ${formatDate(cycleProvider.getNextPeriodDate())}")
                                            : " Disabled", // Disabled message with the same date
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
                                : (showHideProvider.visibilityMap[
                                            'Chance of getting pregnant'] ==
                                        true
                                    ? getpPregnancyChanceText(
                                        context,
                                        lastPeriodDate,
                                        periodLength,
                                        currentCycleDay,
                                        cycleLength,
                                        intercourseProvider)
                                    : "Feature is disabled"),
                            progressLabelStart: isPregnancyMode
                                ? pregnancyModeProvider.gestationStart != null
                                    ? formatDate(
                                        pregnancyModeProvider.gestationStart!)
                                    : ""
                                : formatDate(cycleProvider.lastPeriodStart),
                            progressLabelEnd: isPregnancyMode
                                ? pregnancyModeProvider.dueDate != null
                                    ? formatDate(pregnancyModeProvider.dueDate!)
                                    : ""
                                : formatDate(
                                    cycleProvider.lastPeriodStart.add(
                                      Duration(
                                          days: cycleProvider.cycleLength),
                                    ),
                                  ),
                            progressValue: isPregnancyMode
                                ? (pregnancyModeProvider.gestationWeeks ?? 1) /
                                    40.0
                                : currentCycleDay / cycleProvider.cycleLength ,
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

String getpPregnancyChanceText(
  BuildContext context,
  DateTime lastPeriodDate,
  int periodLength,
  int currentCycleDay,
  int cycleLength,
  IntercourseProvider intercourseProvider,
) {
  // Calculate ovulation window
  int ovulationStart = (cycleLength ~/ 2) - 1; // Adjust as needed
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
    pregnancyChancePercentage = 5.0; // Low chance during period
    chanceText = 'Low chance of pregnancy';
  }
  // Fertile window check
  else if (currentCycleDay >= ovulationStart &&
      currentCycleDay <= ovulationEnd) {
    if (!isProtected) {
      pregnancyChancePercentage =
          intercourseProvider.femaleOrgasm == 'Happened' ? 90.0 : 70.0;
      chanceText = 'High chance of pregnancy';
    } else {
      pregnancyChancePercentage = 20.0; // Low chance with protection
      chanceText = 'Low chance of pregnancy';
    }
  }
  // Approaching fertile window (late period)
  else if (currentCycleDay > periodLength && currentCycleDay < ovulationStart) {
    pregnancyChancePercentage =
        isProtected ? 10.0 : (30.0 + (numberOfTimes * 5.0));
    chanceText =
        isProtected ? 'Low chance of pregnancy' : 'Medium chance of pregnancy';
  }
  // Luteal phase (after ovulation)
  else if (currentCycleDay > ovulationEnd && currentCycleDay <= cycleLength) {
    pregnancyChancePercentage = isProtected ? 5.0 : 30.0;
    chanceText =
        isProtected ? 'Low chance of pregnancy' : 'Medium chance of pregnancy';
  }
  // Late periods and post-cycle
  else if (currentCycleDay > cycleLength) {
    pregnancyChancePercentage =
        20.0; // Some chance of pregnancy after periods end
    chanceText = ' Medium chance of pregnancy';
  }
  // Cycle has ended, no chance
  else {
    return 'No chance of pregnancy (0%).';
  }

  // Cap the percentage at 100%
  pregnancyChancePercentage = pregnancyChancePercentage.clamp(0.0, 100.0);

  return '$chanceText (${pregnancyChancePercentage.toStringAsFixed(1)}%).';
}

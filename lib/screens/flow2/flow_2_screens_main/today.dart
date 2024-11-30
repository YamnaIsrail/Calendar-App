import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/screens/flow2/detail%20page/today_cycle_phase/period_phase.dart';
import 'package:calender_app/screens/settings/settings_page.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/cycle_info_card.dart';
import 'package:calender_app/widgets/cycle_phase_card.dart';
import 'package:calender_app/widgets/flow2_appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CycleStatusScreen extends StatelessWidget {
  final String? userImageUrl;

  CycleStatusScreen({this.userImageUrl});

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<CycleProvider>(context);

    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          pageTitle: "",
          onCancel: () {},
          userImageUrl: userImageUrl,
          onBack: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          },
        ),
        body: Consumer<CycleProvider>(
          builder: (context, cycleProvider, child) {
            final daysUntilNextPeriod = cycleProvider.getDaysUntilNextPeriod();
            final nextPeriodDate = cycleProvider.getNextPeriodDate();
            final currentCycleDay = cycleProvider.daysElapsed + 1;
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
                          daysUntilNextPeriod < 0
                              ? "${daysUntilNextPeriod.abs()} Days Late"
                              : "$daysUntilNextPeriod Days Left",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        SizedBox(height: 5),
                        Text(
                          daysUntilNextPeriod < 0
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => PeriodPhaseScreen()),
                                        );
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
                                        phase: "Menstrual Phase",
                                        date: "Start Date: ${formatDate(cycleProvider.lastPeriodStart)}",
                                      ),
                                      CyclePhaseCard(
                                        icon: Icons.fiber_manual_record,
                                        color: Colors.green[100]!,
                                        phase: "Follicular Phase",
                                        date: "Start Date: ${formatDate(cycleProvider.lastPeriodStart.add(Duration(days: cycleProvider.cycleLength - 14)))}",
                                      ),
                                      CyclePhaseCard(
                                        icon: Icons.beach_access,
                                        color: Colors.blue[100]!,
                                        phase: "Ovulation Phase",
                                        date: "Start Date: ${formatDate(cycleProvider.lastPeriodStart.add(Duration(days: cycleProvider.cycleLength - 14 + 14)))}",
                                      ),
                                      CyclePhaseCard(
                                        icon: Icons.water_drop,
                                        color: Colors.orange[100]!,
                                        phase: "Next Period",
                                        date: "Start Date: ${formatDate(cycleProvider.getNextPeriodDate())}",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),

                          // Today's Cycle Status
                          buildCycleInfoCard(
                            icon: Icons.replay_5,
                            title: ' Today - Cycle Day $currentCycleDay ',
                            subtitle: 'High chance of getting periods',
                            progressLabelStart: formatDate(cycleProvider.lastPeriodStart),
                            progressLabelEnd: formatDate(
                              cycleProvider.lastPeriodStart.add(
                                Duration(days: cycleProvider.periodLength),
                              ),
                            ),
                            progressValue: currentCycleDay / cycleProvider.cycleLength,
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

import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/provider/preg_provider.dart';
import 'package:calender_app/widgets/cycle_info_card.dart';
import 'package:calender_app/widgets/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<CycleProvider>(context);
    final pregnancyProvider = Provider.of<PregnancyModeProvider>(context);
    final now = DateTime.now();

    String _getGreeting() {
      final hour = now.hour;
      if (hour < 12) return "Good Morning!";
      if (hour < 17) return "Good Afternoon!";
      return "Good Evening!";
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "My Calendar",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _getGreeting(),
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),

              // Calendar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2025, 12, 31),
                  focusedDay: DateTime.now(),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, date, _) {
                      final normalizedDate = DateTime(date.year, date.month, date.day);
                      if (pregnancyProvider.isPregnancyMode) {
                        // Pregnancy Mode Calendar Logic
                        if (pregnancyProvider.gestationStart != null) {
                          final pregnancyStartDays = date.difference(pregnancyProvider.gestationStart!).inDays;
                          if (pregnancyStartDays == 0) {
                            return _buildCalendarCell(date: date, color: Colors.green);
                          }
                        }
                      } else {
                        // Cycle Mode Calendar Logic
                        for (var periodStartDateString in cycleProvider.pastPeriods) {
                          final startDate = DateTime.parse(periodStartDateString);  // Parse the start date
                          final periodLength = cycleProvider.periodLength;  // You can get the period length from the provider
                          final endDate = startDate.add(Duration(days: periodLength));  // Calculate the end date

                          // Check if the normalizedDate falls within the cycle's start and end date
                          if (normalizedDate.isAfter(startDate.subtract(Duration(days: 1))) &&
                              normalizedDate.isBefore(endDate.add(Duration(days: 1)))) {
                            return _buildCalendarCell(date: date, color: Colors.red);  // Highlight the date if it's within the cycle
                          }
                        }


                        if (cycleProvider.periodDays.contains(normalizedDate)) {
                          return _buildCalendarCell(date: date, color: Colors.red);
                        }

                        else if (cycleProvider.predictedDays.contains(normalizedDate)) {
                          return _buildCalendarCell(
                            date: date,
                            border: Border.all(color: Colors.blue, width: 2),
                          );
                        } else if (cycleProvider.fertileDays.contains(normalizedDate)) {
                          return _buildCalendarCell(
                            date: date,
                            color: Colors.purple[100],
                          );
                        }
                      }
                      return null;
                    },
                  ),
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: TextStyle(color: Colors.black),
                    weekendTextStyle: TextStyle(color: Colors.red),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
              ),

              // Legend
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: pregnancyProvider.isPregnancyMode
                      ? [
                    _buildLegendItem("Pregnancy Days", Colors.green),
                    _buildLegendItem("Gestation Weeks", Colors.orange),
                  ]
                      : [
                    _buildLegendItem("Period", Colors.red),
                    _buildLegendItem("Predicted Period", Colors.blue, isBorder: true),
                    _buildLegendItem("Fertile Window", Colors.purple[100]!),
                  ],
                ),
              ),

              // Information Cards
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: pregnancyProvider.isPregnancyMode
                      ? [
                    buildPregnancyInfoCard(
                      title: 'Gestation Days Since Start: ${pregnancyProvider.gestationDays} days',
                      subtitle: 'Progress towards due date',
                      icon: Icons.child_care,
                      progressValue: pregnancyProvider.gestationDays! / 280,
                      progressLabelStart: 'Gestation Period',
                      progressLabelEnd: 'Today',
                    ),
                    SizedBox(height: 16),
                    buildPregnancyInfoCard(
                      progressLabelStart: 'Gestation',
                      progressLabelEnd: 'Week',
                      title: 'Weeks of Gestation: ${pregnancyProvider.gestationWeeks} weeks',
                      subtitle: 'Normal pregnancy progression',
                      icon: Icons.replay_5,
                      progressValue: (pregnancyProvider.gestationWeeks! / 40),
                    ),
                  ]
                      : [
                    buildCycleInfoCard(
                      title: 'Started: ${formatDate(cycleProvider.lastPeriodStart)}',
                      subtitle: '${cycleProvider.daysElapsed} days ago',
                      progressLabelStart: 'Last Period',
                      progressLabelEnd: 'Today',
                      progressValue: cycleProvider.daysElapsed / cycleProvider.cycleLength,
                      icon: Icons.timer_outlined,
                    ),
                    SizedBox(height: 16),
                    buildCycleInfoCard(
                      icon: Icons.water_drop,
                      title: 'Period Length: ${cycleProvider.periodLength} days',
                      subtitle: 'Normal',
                      progressLabelStart: formatDate(cycleProvider.lastPeriodStart),
                      progressLabelEnd: formatDate(
                        cycleProvider.lastPeriodStart.add(
                          Duration(days: cycleProvider.periodLength),
                        ),
                      ),
                      progressValue: cycleProvider.daysElapsed / cycleProvider.periodLength,
                    ),
                    SizedBox(height: 16),
                    buildCycleInfoCard(
                      icon: Icons.replay_5,
                      title: 'Cycle Length: ${cycleProvider.cycleLength} days',
                      subtitle: 'High chance of getting periods',
                      progressLabelStart: formatDate(cycleProvider.lastPeriodStart),
                      progressLabelEnd: formatDate(
                        cycleProvider.lastPeriodStart.add(
                          Duration(days: cycleProvider.cycleLength),
                        ),
                      ),
                      progressValue: cycleProvider.daysElapsed / cycleProvider.cycleLength,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarCell({
    required DateTime date,
    Color? color,
    Border? border,
  }) {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color,
        border: border,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          date.day.toString(),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, {bool isBorder = false}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: isBorder ? Colors.transparent : color,
            border: isBorder ? Border.all(color: color, width: 2) : null,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}


class CustomC1alendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<CycleProvider>(context);
    final now = DateTime.now();

    String _getGreeting() {
      final hour = now.hour;
      if (hour < 12) return "Good Morning!";
      if (hour < 17) return "Good Afternoon!";
      return "Good Evening!";
    }


    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "My Calendar",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _getGreeting(),
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),

              // Calendar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2025, 12, 31),
                  focusedDay: DateTime.now(),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, date, _) {
                      final normalizedDate = DateTime(date.year, date.month, date.day);
                      if (cycleProvider.periodDays.contains(normalizedDate)) {
                        return _buildCalendarCell(date: date, color: Colors.red);
                      } else if (cycleProvider.predictedDays.contains(normalizedDate)) {
                        return _buildCalendarCell(
                          date: date,
                          border: Border.all(color: Colors.blue, width: 2),
                        );
                      } else if (cycleProvider.fertileDays.contains(normalizedDate)) {
                        return _buildCalendarCell(
                          date: date,
                          color: Colors.purple[100],
                        );
                      }
                      return null;
                    },
                  ),
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: TextStyle(color: Colors.black),
                    weekendTextStyle: TextStyle(color: Colors.red),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
              ),

              // Legend
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildLegendItem("Period", Colors.red),
                    _buildLegendItem("Predicted Period", Colors.blue, isBorder: true),
                    _buildLegendItem("Fertile Window", Colors.purple[100]!),
                  ],
                ),
              ),

              // Cycle Info Cards
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildCycleInfoCard(
                      title: 'Started: ${formatDate(cycleProvider.lastPeriodStart)}',
                      subtitle: '${cycleProvider.daysElapsed} days ago',
                      progressLabelStart: 'Last Period',
                      progressLabelEnd: 'Today',
                      progressValue: cycleProvider.daysElapsed/ cycleProvider.cycleLength,
                      icon: Icons.timer_outlined,
                    ),
                    SizedBox(height: 16),
                    buildCycleInfoCard(
                      icon: Icons.water_drop,
                      title: 'Period Length: ${cycleProvider.periodLength} days',
                      subtitle: 'Normal',
                      progressLabelStart: formatDate(cycleProvider.lastPeriodStart),
                      progressLabelEnd: formatDate(
                        cycleProvider.lastPeriodStart.add(
                          Duration(days: cycleProvider.periodLength),
                        ),
                      ),
                      progressValue: cycleProvider.daysElapsed/ cycleProvider.periodLength,
                    ),
                    SizedBox(height: 16),
                    buildCycleInfoCard(
                      icon: Icons.replay_5,
                      title: 'Cycle Length: ${cycleProvider.cycleLength} days',
                      subtitle: 'High chance of getting periods',
                      progressLabelStart: formatDate(cycleProvider.lastPeriodStart),
                      progressLabelEnd: formatDate(
                        cycleProvider.lastPeriodStart.add(
                          Duration(days: cycleProvider.cycleLength),
                        ),
                      ),
                      progressValue: cycleProvider.daysElapsed / cycleProvider.cycleLength,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarCell({
    required DateTime date,
    Color? color,
    Border? border,
  }) {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color,
        border: border,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          date.day.toString(),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, {bool isBorder = false}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: isBorder ? Colors.transparent : color,
            border: isBorder ? Border.all(color: color, width: 2) : null,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(label),
      ],
    );
  }

}

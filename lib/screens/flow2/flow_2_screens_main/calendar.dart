import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/screens/settings/settings_page.dart';
import 'package:calender_app/widgets/flow2_appbar.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:provider/provider.dart';

class CustomCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<CycleProvider>(context);

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
          title: Text("My Calendar", style: TextStyle(color: Colors.white)),
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
                  "Good Morning!",
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
                  firstDay: DateTime.utc(2024, 1, 1),
                  lastDay: DateTime.utc(2024, 12, 31),
                  focusedDay: DateTime.now(),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, date, focusedDay) {
                      // Normalize the date to midnight to avoid time mismatches
                      DateTime normalizedDate = DateTime(date.year, date.month, date.day);

                      if (cycleProvider.periodDays.any((d) => DateTime(d.year, d.month, d.day) == normalizedDate)) {
                        return _buildCalendarCell(
                          date: date,
                          color: Colors.red,
                        );
                      } else if (cycleProvider.predictedDays.any((d) => DateTime(d.year, d.month, d.day) == normalizedDate)) {
                        return _buildCalendarCell(
                          date: date,
                          border: Border.all(color: Colors.blue, width: 2),
                        );
                      } else if (cycleProvider.fertileDays.any((d) => DateTime(d.year, d.month, d.day) == normalizedDate)) {
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
                    _buildLegendItem(
                        "Predicted Period", Colors.blue, isBorder: true),
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

                    _buildCycleInfoCard(
                      title: 'Started: ${cycleProvider.lastPeriodStart}',
                      subtitle: '${cycleProvider.daysElapsed} days ago',
                      progressLabelStart: 'Last Period',
                      progressLabelEnd: 'Today',
                      progressValue: 0.5,
                      icon: Icons.timer_outlined,
                    ),
                    SizedBox(height: 16),
                    _buildCycleInfoCard(
                      icon: Icons.water_drop,
                      title: 'Period Length: ${cycleProvider.periodLength} days',
                      subtitle: 'Normal',
                      progressLabelStart: 'Oct 3',
                      progressLabelEnd: 'Today',
                      progressValue: 0.55,
                    ),
                    SizedBox(height: 16),
                    _buildCycleInfoCard(
                      icon: Icons.replay_5,
                      title: 'Cycle Length: ${cycleProvider.cycleLength} days',
                      subtitle: 'High chance of getting periods',
                      progressLabelStart: 'Oct 3',
                      progressLabelEnd: 'Today',
                      progressValue: 0.55,
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
      margin: EdgeInsets.all(4), // Adjust margin for spacing
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

  Widget _buildCycleInfoCard({
    required String title,
    required String subtitle,
    required String progressLabelStart,
    required String progressLabelEnd,
    required double progressValue,
    required IconData icon,
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
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.pink, size: 24),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          SizedBox(height: 16),
          LinearProgressIndicator(
            value: progressValue,
            backgroundColor: Colors.grey[200],
            color: Colors.pink,
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(progressLabelStart),
              Text(progressLabelEnd),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatelessWidget {
  final List<DateTime> cycleDays = [
    DateTime(2024, 11, 21),
    DateTime(2024, 11, 22),
    DateTime(2024, 11, 23),
    DateTime(2024, 11, 24),
    DateTime(2024, 11, 25),
  ];

  final List<DateTime> predictedPeriod = [
    DateTime(2024, 11, 26),
  ];

  final List<DateTime> fertileWindow = [
    DateTime(2024, 11, 27),
    DateTime(2024, 11, 28),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Calendar'),
      ),
      body: SingleChildScrollView(

        child: Column(
          children: [
            SizedBox(
              height: 350,
             // width: 350,
              child: TableCalendar(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2024, 12, 31),
                focusedDay: DateTime.now(),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, date, focusedDay) {
                    if (cycleDays.contains(date)) {
                      return Container(
                        color: Colors.red,
                        child: Center(
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    } else if (predictedPeriod.contains(date)) {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue, width: 2),
                        ),
                        child: Center(child: Text(date.day.toString())),
                      );
                    } else if (fertileWindow.contains(date)) {
                      return Container(
                        color: Colors.purple[100],
                        child: Center(child: Text(date.day.toString())),
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCycleInfoCard(
                    title: ' Started June 27',
                    subtitle: '18 days ago',
                    progressLabelStart: 'Oct 3',
                    progressLabelEnd: 'Today',
                    progressValue: 0.55, icon: Icons.timer_outlined,
                  ),
                  SizedBox(height: 16),
                  _buildCycleInfoCard(
                    icon: Icons.water_drop,
                    title: 'Period Length 4 days',
                    subtitle: 'Normal',
                    progressLabelStart: 'Oct 3',
                    progressLabelEnd: 'Today',
                    progressValue: 0.55,
                  ),
                  SizedBox(height: 16),
                  _buildCycleInfoCard(
                    icon: Icons.replay_5,
                    title: 'cycle length',
                    subtitle: 'HIGH - Chance of getting periods',
                    progressLabelStart: 'Oct 3',
                    progressLabelEnd: 'Today',
                    progressValue: 0.55,
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: ElevatedButton(
            //     onPressed: () {},
            //     style: ElevatedButton.styleFrom(
            //       foregroundColor: Colors.white,
            //       backgroundColor: Colors.pink[500],
            //     ),
            //     child: Text('Update Cycle Data'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildCycleInfoCard({
    required String title,
    required String subtitle,
    required String progressLabelStart,
    required String progressLabelEnd,
    required double progressValue,
    required IconData icon, // Add icon parameter
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
          Row(
            children: [
              Icon(icon, color: Colors.pink, size: 24), // Add the icon here
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 16),

        ],
      ),
    );
  }}

// import 'package:calender_app/provider/preg_provider.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/widgets/cycle_info_card.dart';
import 'package:calender_app/widgets/date_format.dart';


class PartnerModeCalendar extends StatefulWidget {
  @override
  _PartnerModeCalendarState createState() => _PartnerModeCalendarState();
}

class _PartnerModeCalendarState extends State<PartnerModeCalendar> {
  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<CycleProvider>(context);
    final pregProvider = Provider.of<PregnancyProvider>(context);
    final currentWeek = pregProvider.getCurrentWeek();
    final daysUntilDueDate = pregProvider.getDaysUntilDueDate();


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
                      }

                      // Predicted periods
                      if (cycleProvider.predictedDays.contains(normalizedDate)) {
                        return _buildCalendarCell(
                          date: date,
                          border: Border.all(color: Colors.blue, width: 2),
                        );
                      }

                      // Fertile window (common for periods and pregnancy tracking)
                      if (cycleProvider.fertileDays.contains(normalizedDate)) {
                        return _buildCalendarCell(date: date, color: Colors.purple[100]);
                      }

                      // Pregnancy-specific highlights
                      if (cycleProvider.fertileDays.contains(normalizedDate)) {
                        return _buildCalendarCell(date: date, color: Colors.orange);
                      }

                      if (normalizedDate == pregProvider.dueDate) {
                        return _buildCalendarCell(
                          date: date,
                          color: Colors.green,
                          isBold: true,
                          isSelected: true,
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Expanded(
                    child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildLegendItem("Period", Colors.red),
                        _buildLegendItem("Predicted Period", Colors.blue, isBorder: true),
                        _buildLegendItem("Fertile Window", Colors.purple[100]!),
                        _buildLegendItem("Ovulation", Colors.orange),
                        _buildLegendItem("Due Date", Colors.green),
                      ],
                    ),
                  ),
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
                      progressValue: cycleProvider.daysElapsed / cycleProvider.cycleLength,
                      icon: Icons.timer_outlined,
                    ),
                       SizedBox(height: 10,),
                       buildCycleInfoCard(
                        title: 'Due Date: ${formatDate(pregProvider.dueDate!)}',
                        subtitle: 'Approximate',
                        progressLabelStart: 'Start of Pregnancy',
                        progressLabelEnd: 'Due Date',
                        progressValue: currentWeek.toDouble(),
                        icon: Icons.child_care,
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
    bool isBold = false,
    bool isSelected = false,
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
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
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

// class PartnerModeCalendar extends StatelessWidget {
//   final List<DateTime> cycleDays = [
//     DateTime(2024, 11, 21),
//     DateTime(2024, 11, 22),
//     DateTime(2024, 11, 23),
//     DateTime(2024, 11, 24),
//     DateTime(2024, 11, 25),
//   ];
//
//   final List<DateTime> predictedPeriod = [
//     DateTime(2024, 11, 26),
//   ];
//
//   final List<DateTime> fertileWindow = [
//     DateTime(2024, 11, 27),
//     DateTime(2024, 11, 28),
//   ];
//
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
//       ),
//       body:  Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/bg.jpg'),
//             fit: BoxFit.cover, // Adjust the fit as needed (cover, contain, fill, etc.)
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 350,
//                 // width: 350,
//                 child: Container(
//                   color: Colors.white,
//                   child: TableCalendar(
//                     firstDay: DateTime.utc(2024, 1, 1),
//                     lastDay: DateTime.utc(2024, 12, 31),
//                     focusedDay: DateTime.now(),
//                     calendarBuilders: CalendarBuilders(
//                       defaultBuilder: (context, date, focusedDay) {
//                         if (cycleDays.contains(date)) {
//                           return Container(
//                             color: Colors.red,
//                             child: Center(
//                               child: Text(
//                                 date.day.toString(),
//                                 style: TextStyle(color: Colors.black),
//                               ),
//                             ),
//                           );
//                         } else if (predictedPeriod.contains(date)) {
//                           return Container(
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border: Border.all(color: Colors.blue, width: 2),
//                             ),
//                             child: Center(child: Text(date.day.toString())),
//                           );
//                         } else if (fertileWindow.contains(date)) {
//                           return Container(
//                             color: Colors.purple[100],
//                             child: Center(child: Text(date.day.toString())),
//                           );
//                         }
//                         return null;
//                       },
//                     ),
//                     calendarStyle: CalendarStyle(
//                       defaultTextStyle: TextStyle(color: Colors.black),
//                       weekendTextStyle: TextStyle(color: Colors.red),
//                     ),
//                     headerStyle: HeaderStyle(
//                       formatButtonVisible: false,
//                       titleCentered: true,
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildCycleInfoCard(
//                       title: ' Started June 27',
//                       subtitle: '18 days ago',
//                       progressLabelStart: 'Oct 3',
//                       progressLabelEnd: 'Today',
//                       progressValue: 0.55, icon: Icons.timer_outlined,
//                     ),
//                     SizedBox(height: 16),
//                     _buildCycleInfoCard(
//                       icon: Icons.water_drop,
//                       title: 'Period Length 4 days',
//                       subtitle: 'Normal',
//                       progressLabelStart: 'Oct 3',
//                       progressLabelEnd: 'Today',
//                       progressValue: 0.55,
//                     ),
//                     SizedBox(height: 16),
//                     _buildCycleInfoCard(
//                       icon: Icons.replay_5,
//                       title: 'cycle length',
//                       subtitle: 'HIGH - Chance of getting periods',
//                       progressLabelStart: 'Oct 3',
//                       progressLabelEnd: 'Today',
//                       progressValue: 0.55,
//                     ),
//                   ],
//                 ),
//               ),
//               // Padding(
//               //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               //   child: ElevatedButton(
//               //     onPressed: () {},
//               //     style: ElevatedButton.styleFrom(
//               //       foregroundColor: Colors.white,
//               //       backgroundColor: Colors.pink[500],
//               //     ),
//               //     child: Text('Update Cycle Data'),
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCycleInfoCard({
//     required String title,
//     required String subtitle,
//     required String progressLabelStart,
//     required String progressLabelEnd,
//     required double progressValue,
//     required IconData icon, // Add icon parameter
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.3),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: Colors.pink, size: 24), // Add the icon here
//               SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 8),
//           Text(
//             subtitle,
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.red,
//             ),
//           ),
//           SizedBox(height: 16),
//
//         ],
//       ),
//     );
//   }}

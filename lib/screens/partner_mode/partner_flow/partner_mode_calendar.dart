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
    final partnerProvider = Provider.of<PartnerProvider>(context);
   final isPregnancyMode = partnerProvider.pregnancyMode;
    // final isPregnancyMode =false;

    final currentWeek = isPregnancyMode ? partnerProvider.getCurrentWeek() : null;
    final daysUntilDueDate = isPregnancyMode ? partnerProvider.daysUntilDueDate : null;
    final daysElapsed = partnerProvider.daysElapsed;
    final cycleLength = partnerProvider.cycleLength ?? 0;
    final periodLength = partnerProvider.periodLength ?? 0;
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

                      if (isPregnancyMode) {
                        // Highlight due date with a specific color
                        if (partnerProvider.dueDate != null &&
                            DateUtils.isSameDay(normalizedDate, partnerProvider.dueDate)) {
                          return _buildCalendarCell(
                            date: date,
                            color: Colors.green,
                            isBold: true,
                            isSelected: true,
                          );
                        }

                        // Highlight current week
                        if (currentWeek != null && partnerProvider.gestationStart != null) {
                          // Calculate start and end of the current week
                          final startOfWeek = partnerProvider.gestationStart!.add(Duration(days: (currentWeek - 1) * 7));
                          final endOfWeek = startOfWeek.add(Duration(days: 6));

                          if (normalizedDate.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
                              normalizedDate.isBefore(endOfWeek.add(Duration(days: 1)))) {
                            return _buildCalendarCell(
                              date: date,
                              color: Colors.orange[300],
                              isBold: true,
                            );
                          }
                        }

                        // Default pregnancy mode cell
                        return _buildCalendarCell(
                          date: date,
                          color: Colors.grey[200],
                        );
                      }
                      else {
                        // Non-pregnancy mode (period tracking)

                        // Period days
                        if (partnerProvider.periodDays.contains(normalizedDate)) {
                          return _buildCalendarCell(date: date, color: Colors.red);
                        }

                        // Predicted periods
                        if (partnerProvider.predictedDays.contains(normalizedDate)) {
                          return _buildCalendarCell(
                            date: date,
                            border: Border.all(color: Colors.blue, width: 2),
                          );
                        }

                        // Fertile window
                        if (partnerProvider.fertileDays.contains(normalizedDate)) {
                          return _buildCalendarCell(date: date, color: Colors.purple[100]);
                        }

                        // Default cell for other dates
                        return null;
                      }
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: isPregnancyMode
                          ? [
                        _buildLegendItem("Due Date", Colors.green),
                        _buildLegendItem("Current Week", Colors.orange[300]!),
                        _buildLegendItem("Neutral Days", Colors.grey[200]!),
                      ]
                          : [
                        _buildLegendItem("Period", Colors.red),
                        _buildLegendItem("Predicted Period", Colors.blue, isBorder: true),
                        _buildLegendItem("Fertile Window", Colors.purple[100]!),
                      ],
                    ),
                  ],
                ),
              ),


              // Info Cards
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: isPregnancyMode
                      ? [
                    buildCycleInfoCard(
                      title: 'Current Week: $currentWeek',
                      subtitle: 'Tracking weekly progress',
                      progressLabelStart: 'Start of Pregnancy',
                      progressLabelEnd: 'Due Date: ${partnerProvider.dueDate != null ? formatDate(partnerProvider.dueDate!) : "No Due Date"}',

                      progressValue: (280 - daysUntilDueDate!) / 280, // Approx. progress
                      icon: Icons.calendar_today,
                    ),]
                      : [
                    buildCycleInfoCard(
                      title: 'Started: ${partnerProvider.lastMenstrualPeriod != null ? formatDate(partnerProvider.lastMenstrualPeriod!) : "No Data"}',
                      subtitle: '$daysElapsed days ago',
                      progressLabelStart: 'Last Period',
                      progressLabelEnd: 'Today',
                      progressValue: cycleLength > 0 ? daysElapsed / cycleLength : 0.0,
                      icon: Icons.timer_outlined,
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


//
// class xPartnerModeCalendar extends StatefulWidget {
//   @override
//   _xPartnerModeCalendarState createState() => _xPartnerModeCalendarState();
// }
//
// class _xPartnerModeCalendarState extends State<xPartnerModeCalendar> {
//   @override
//   Widget build(BuildContext context) {
//     final partnerProvider = Provider.of<PartnerProvider>(context);
//     final currentWeek = partnerProvider.getCurrentWeek();
//     final daysUntilDueDate = partnerProvider.getDaysIntoPregnancy();
//
//
//     final now = DateTime.now();
//
//     String _getGreeting() {
//       final hour = now.hour;
//       if (hour < 12) return "Good Morning!";
//       if (hour < 17) return "Good Afternoon!";
//       return "Good Evening!";
//     }
//
//     return Container(
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage('assets/bg.jpg'),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           title: Text(
//             "My Calendar",
//             style: TextStyle(color: Colors.white),
//           ),
//           centerTitle: true,
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Greeting
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text(
//                   _getGreeting(),
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                 ),
//               ),
//
//               // Calendar
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.3),
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: TableCalendar(
//                   firstDay: DateTime.utc(2020, 1, 1),
//                   lastDay: DateTime.utc(2025, 12, 31),
//                   focusedDay: DateTime.now(),
//                   calendarBuilders: CalendarBuilders(
//                     defaultBuilder: (context, date, _) {
//                       final normalizedDate = DateTime(date.year, date.month, date.day);
//
//                       if (partnerProvider.periodDays.contains(normalizedDate)) {
//                         return _buildCalendarCell(date: date, color: Colors.red);
//                       }
//
//                       // Predicted periods
//                       if (partnerProvider.predictedDays.contains(normalizedDate)) {
//                         return _buildCalendarCell(
//                           date: date,
//                           border: Border.all(color: Colors.blue, width: 2),
//                         );
//                       }
//
//                       // Fertile window (common for periods and pregnancy tracking)
//                       if (partnerProvider.fertileDays.contains(normalizedDate)) {
//                         return _buildCalendarCell(date: date, color: Colors.purple[100]);
//                       }
//
//                       // Pregnancy-specific highlights
//                       if (partnerProvider.fertileDays.contains(normalizedDate)) {
//                         return _buildCalendarCell(date: date, color: Colors.orange);
//                       }
//
//                       if (normalizedDate == partnerProvider.dueDate) {
//                         return _buildCalendarCell(
//                           date: date,
//                           color: Colors.green,
//                           isBold: true,
//                           isSelected: true,
//                         );
//                       }
//
//                       return null;
//                     },
//                   ),
//                   calendarStyle: CalendarStyle(
//                     defaultTextStyle: TextStyle(color: Colors.black),
//                     weekendTextStyle: TextStyle(color: Colors.red),
//                   ),
//                   headerStyle: HeaderStyle(
//                     formatButtonVisible: false,
//                     titleCentered: true,
//                   ),
//                 ),
//               ),
//
//               // Legend
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildLegendItem("Period", Colors.red),
//                         _buildLegendItem("Predicted Period", Colors.blue, isBorder: true),
//
//                       ],
//                     ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                       _buildLegendItem("Fertile Window", Colors.purple[100]!),
//                       _buildLegendItem("Ovulation", Colors.orange),
//                       _buildLegendItem("Due Date", Colors.green),
//
//                     ],),
//                      ],
//                 ),
//               ),
//
//               // Cycle Info Cards
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     buildCycleInfoCard(
//                       title: 'Started: ${partnerProvider.lastMenstrualPeriod != null ? formatDate(partnerProvider.lastMenstrualPeriod!) : "No Data"}',
//                       subtitle: '${partnerProvider.daysElapsed} days ago',
//                       progressLabelStart: 'Last Period',
//                       progressLabelEnd: 'Today',
//                       progressValue: partnerProvider.cycleLength != null && partnerProvider.cycleLength! > 0
//                           ? partnerProvider.daysElapsed / partnerProvider.cycleLength!
//                           : 0.0,
//                       icon: Icons.timer_outlined,
//                     ),
//                        SizedBox(height: 10,),
//                        buildCycleInfoCard(
//                          title: 'Due Date: ${partnerProvider.dueDate != null ? formatDate(partnerProvider.dueDate!) : "No Due Date"}',
//                          subtitle: 'Approximate',
//                         progressLabelStart: 'Start of Pregnancy',
//                         progressLabelEnd: 'Due Date',
//                         progressValue: currentWeek.toDouble(),
//                         icon: Icons.child_care,
//                       ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCalendarCell({
//     required DateTime date,
//     Color? color,
//     Border? border,
//     bool isBold = false,
//     bool isSelected = false,
//   }) {
//     return Container(
//       margin: EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         color: color,
//         border: border,
//         shape: BoxShape.circle,
//       ),
//       child: Center(
//         child: Text(
//           date.day.toString(),
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.black,
//             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLegendItem(String label, Color color, {bool isBorder = false}) {
//     return Row(
//       children: [
//         Container(
//           width: 16,
//           height: 16,
//           decoration: BoxDecoration(
//             color: isBorder ? Colors.transparent : color,
//             border: isBorder ? Border.all(color: color, width: 2) : null,
//             shape: BoxShape.circle,
//           ),
//         ),
//         SizedBox(width: 8),
//         Text(label),
//       ],
//     );
//   }
// }
//

import 'package:calender_app/provider/date_day_format.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:calender_app/provider/partner_provider.dart';
import 'package:calender_app/widgets/cycle_info_card.dart';
import 'package:intl/intl.dart';
import 'package:calender_app/admob/banner_ad.dart';
class PartnerModeCalendar extends StatefulWidget {
  @override
  _PartnerModeCalendarState createState() => _PartnerModeCalendarState();
}

class _PartnerModeCalendarState extends
State<PartnerModeCalendar> {
  @override
  Widget build(BuildContext context) {
    final partnerProvider = Provider.of<PartnerProvider>(context);
    final isPregnancyMode = partnerProvider.pregnancyMode;
    // final isPregnancyMode =false;

    final currentWeek = isPregnancyMode ? partnerProvider.gestationWeeks : 1;
    final currentDay = isPregnancyMode ? partnerProvider.gestationDays : 1;
    final daysUntilDueDate = isPregnancyMode ? partnerProvider.daysUntilDueDate : null;
    final daysElapsed = partnerProvider.daysElapsed;
    final cycleLength = partnerProvider.cycleLength ?? 0;
    final periodLength = partnerProvider.periodLength ?? 0;
    final now = DateTime.now();

    double progress =  (currentWeek + (currentDay / 7)) / 40;


    String formatDate(DateTime date) {
      String selectedFormat = context.watch<SettingsModel>().dateFormat;
      if (selectedFormat == "System Default") {
        return DateFormat.yMd().format(date); // Use system locale's default
      } else {
        return DateFormat(selectedFormat).format(date); // Use selected format
      }
    }
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
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                child: Consumer<PartnerProvider>(
                    builder: (context, partnerProvider, child) {
                      return TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2025, 12, 31),
                      focusedDay: DateTime.now(),
                      calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, date, _) {
                            final normalizedDate = DateTime(date.year, date.month, date.day);
                            Widget calendarCell = _buildCalendarCell(date: date); // Initial cell without any color

                            if (isPregnancyMode) {
                              if (partnerProvider.gestationStart != null && partnerProvider.dueDate != null) {
                                final pregnancyStartDate = partnerProvider.gestationStart!.toLocal();
                                final dueDate = partnerProvider.dueDate!.toLocal();
                                final currentDate = date.toLocal();

                                // Highlight the gestation start date in green
                                if (currentDate.year == pregnancyStartDate.year &&
                                    currentDate.month == pregnancyStartDate.month &&
                                    currentDate.day == pregnancyStartDate.day) {
                                  calendarCell = _buildCalendarCell(date: date, color: Colors.green);
                                }

                                // Highlight the due date in orange
                                else if (currentDate.year == dueDate.year &&
                                    currentDate.month == dueDate.month &&
                                    currentDate.day == dueDate.day) {
                                  calendarCell = _buildCalendarCell(date: date, color: Colors.orange);
                                }

                                // Highlight dates between gestation start and due date in light green or light grey
                                else if (currentDate.isAfter(pregnancyStartDate) && currentDate.isBefore(dueDate)) {
                                  calendarCell = _buildCalendarCell(date: date, color: Colors.green[100]); // Light green or light grey
                                }
                              }
                            }
                            else {

                              // Default color and border
                              Color? cellColor;
                              Border? cellBorder;

                              // Check priority: Periods > Predicted > Fertile
                              bool isPeriod = partnerProvider.pastPeriods.any((period) {
                                final startDate = DateTime.parse(period['startDate']!);
                                final endDate = DateTime.parse(period['endDate']!);
                                return normalizedDate.isAfter(startDate) && normalizedDate.isBefore(endDate) ;
                              });

                              bool isPredicted = partnerProvider.predictedDays.contains(normalizedDate);
                              bool isFertile = partnerProvider.fertileDays.contains(normalizedDate);

                              if (isPeriod) {
                                cellColor = Colors.red;
                              } else if (isPredicted) {
                                cellBorder = Border.all(color: Colors.blue, width: 2);
                              } else if (isFertile) {
                                cellColor = Colors.purple[100];
                              }

                              return _buildCalendarCell(
                                date: date,
                                color: cellColor,
                                border: cellBorder,
                              );
                            }
                            },
                        ),
                      calendarStyle: CalendarStyle(
                        defaultTextStyle: TextStyle(color: Colors.black),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                    );
                  }
                ),
              ),

              // Legend
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: isPregnancyMode
                      ? [
                    _buildLegendItem("Gestation Start", Colors.green),
                    _buildLegendItem("Pregnancy Duration", Colors.green[100]!),
                    _buildLegendItem("Due Date", Colors.orange[300]!),
                  ]
                      : [
                    _buildLegendItem("Period", Colors.red),
                    _buildLegendItem("Predicted Period", Colors.blue, isBorder: true),
                    _buildLegendItem("Fertile Window", Colors.purple[100]!),
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

                      progressValue: progress, // Approx. progress
                      icon: Icons.calendar_today,
                    ),]
                      : [
                    buildCycleInfoCard(
                      title: 'Started: ${partnerProvider.lastMenstrualPeriod != null ? formatDate(partnerProvider.lastMenstrualPeriod!) : "No Data"}',
                      subtitle: '$daysElapsed days ago',
                      progressLabelStart: 'Last Period',
                      progressLabelEnd: 'Today',
                      progressValue: (daysElapsed /
                          cycleLength)
                          .clamp(0.0, 1.0),
                      icon: Icons.timer_outlined,
                    ),
                  ],
                ),
              ),

              BannerAdWidget(),
              SizedBox(height: 12),

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

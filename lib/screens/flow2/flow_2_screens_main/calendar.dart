import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/provider/date_day_format.dart';
import 'package:calender_app/provider/intercourse_provider.dart';
import 'package:calender_app/provider/preg_provider.dart';
import 'package:calender_app/screens/flow2/flow_2_screens_main/today.dart';
import 'package:calender_app/widgets/cycle_info_card.dart';

import 'package:calender_app/screens/flow2/detail%20page/analysis/timeline/time_line_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../../provider/showhide.dart';
import '../../../admob/banner_ad.dart';

class CustomCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final showHideProvider = context.watch<ShowHideProvider>();
    final timelineProvider = context.watch<TimelineProvider>(); // Use watch to rebuild on changes

    String formatDate(DateTime date) {
      String selectedFormat = context.watch<SettingsModel>().dateFormat;
      if (selectedFormat == "System Default") {
        return DateFormat.yMd().format(date); // Use system locale's default
      } else {
        return DateFormat(selectedFormat).format(date); // Use selected format
      }
    }

    final cycleProvider = Provider.of<CycleProvider>(context);
    final pregnancyProvider = Provider.of<PregnancyModeProvider>(context);
    final intercourseProvider = Provider.of<IntercourseProvider>(context);

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
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: TextStyle(color: Colors.black),
                    weekendTextStyle: TextStyle(color: Colors.red),
                    todayDecoration: BoxDecoration(
                      color: Colors.transparent, // No background; let `todayBuilder` handle it
                      shape: BoxShape.circle,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, date, _) {
                      final normalizedDate = DateTime(date.year, date.month, date.day);

                      // Check if there are timeline entries for the given date
                      bool hasTimelineEntries = timelineProvider.entries.any((entry) {
                        final entryDate = DateTime(entry.date.year, entry.date.month, entry.date.day);
                        return entryDate.isAtSameMomentAs(normalizedDate);
                      });

                      // Default calendar cell
                      Widget calendarCell = _buildCalendarCell(date: date);

                      // Variable to track if the date is in a period
                      bool isInPeriod = false;

                      // Pregnancy Mode Logic
                      if (pregnancyProvider.isPregnancyMode) {
                        if (pregnancyProvider.gestationStart != null && pregnancyProvider.dueDate != null) {
                          final pregnancyStartDate = pregnancyProvider.gestationStart!.toLocal();
                          final dueDate = pregnancyProvider.dueDate!.toLocal();
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
                      // Cycle Mode Logic
                      else {
                        bool isFertile = cycleProvider.fertileDays.contains(normalizedDate);
                        bool isPredicted = cycleProvider.predictedDays.contains(normalizedDate);
                        bool isInPeriod = false;

                        // Check if the date falls within any past period
                        for (var period in cycleProvider.pastPeriods) {
                          final startDate = DateTime.parse(period['startDate']!);
                          final endDate = DateTime.parse(period['endDate']!);

                          if (normalizedDate.isAfter(startDate.subtract(Duration(days: 1))) &&
                              normalizedDate.isBefore(endDate)) {
                            isInPeriod = true;
                            break;
                          }
                        }

                        // Assign colors based on priority
                        if (isInPeriod) {
                          calendarCell = _buildCalendarCell(date: date, color: Colors.red);
                        } else if (isPredicted && isFertile) {
                          calendarCell = _buildCalendarCell(
                            date: date,
                            border: Border.all(color: Colors.blue, width: 2),
                            color: Colors.purple[100], // Combined effect
                          );
                        } else if (isPredicted) {
                          calendarCell = _buildCalendarCell(
                            date: date,
                            border: Border.all(color: Colors.blue, width: 2),
                          );
                        } else if (isFertile) {
                          calendarCell = _buildCalendarCell(
                            date: date,
                            color: Colors.purple[100],
                          );
                        }
                      }
                      // Overlay the heart icon if there are timeline entries
                      if (hasTimelineEntries) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            calendarCell,
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Icon(
                                Icons.favorite,
                                color: isInPeriod ? Colors.purple[200] : Colors.red, // Change color if in period
                                size: 16,
                              ),
                            ),
                          ],
                        );
                      }

                      return calendarCell; // Return the cell without the icon if no entries
                    },
                    todayBuilder: (context, date, _) {
                      final normalizedDate = DateTime(date.year, date.month, date.day);

                      // Default cell (greyish blue for today)
                      Widget calendarCell = _buildCalendarCell(date: date,
                          color: Color(0xff8cbae5));

                      // Check if there are timeline entries for today
                      bool hasTimelineEntries = timelineProvider.entries.any((entry) {
                        final entryDate = DateTime(entry.date.year, entry.date.month, entry.date.day);
                        return entryDate.isAtSameMomentAs(normalizedDate);
                      });

                      // Overlay the heart icon if there are timeline entries
                      if (hasTimelineEntries) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            calendarCell,
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Icon(
                                Icons.favorite,
                                color: Colors.red, // Heart color if there's a timeline entry
                                size: 16,
                              ),
                            ),
                          ],
                        );
                      }

                      return calendarCell; // Return today cell without the icon if no entries
                    },

                  ),

                  onDaySelected: (selectedDay, focusedDay) {

                    _showEntriesForSelectedDate(context, selectedDay);
                  },
                )

                ),

              // Legend
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: pregnancyProvider.isPregnancyMode
                      ? [
                    _buildLegendItem("Start", Colors.green),
                    _buildLegendItem("Duration", Colors.green[100]!),
                    _buildLegendItem("Due Date", Colors.orange),
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
                      title: 'Gestation Started ${formatDate(pregnancyProvider.gestationStart!)}',
                      subtitle: '${pregnancyProvider.daysSinceGestation} days ago',
                      icon: Icons.child_care,
                    ),
                    SizedBox(height: 16),
                    buildPregnancyInfoCard(
                      title: 'Weeks of Gestation: ${pregnancyProvider.gestationWeeks} weeks',
                      subtitle: 'Pregnancy progression',
                      icon: Icons.replay_5,
                 ),
                  ]
                      : [
                    buildCycleInfoCard(
                      title: 'Started: ${formatDate(cycleProvider.lastPeriodStart)}',
                      subtitle: '${cycleProvider.daysElapsed} days ago',
                      icon: Icons.timer_outlined,
                    ),
                    SizedBox(height: 16),
                    buildCycleInfoCard(
                      icon: Icons.water_drop,
                      title: 'Period Length: ${cycleProvider.periodLength} days',
                      subtitle: 'Normal',
                       ),
                    SizedBox(height: 16),
                    buildCycleInfoCard(
                      icon: Icons.replay_5,
                      title: 'Cycle Length: ${cycleProvider.cycleLength} days',
                      subtitle: (showHideProvider.visibilityMap['Chance of getting pregnant'] == true
                          ? getpPregnancyChanceText(
                          context,
                          cycleProvider.lastPeriodStart,
                          cycleProvider.periodLength,
                          cycleProvider.cycleDay,
                          cycleProvider.cycleLength,
                          intercourseProvider)
                          : "Feature is disabled"),
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

  void _showEntriesForSelectedDate(BuildContext context, DateTime selectedDate) {
    String formatDate(DateTime date) {
      String selectedFormat = context.watch<SettingsModel>().dateFormat;
      if (selectedFormat == "System Default") {
        return DateFormat.yMd().format(date); // Use system locale's default
      } else {
        return DateFormat(selectedFormat).format(date); // Use selected format
      }
    }

    // Get the entries from the TimelineProvider
    final timelineProvider = context.read<TimelineProvider>();

    // Normalize selectedDate and entry.date to remove time differences
    final entriesForSelectedDate = timelineProvider.entries
        .where((entry) {
      final entryDate = DateTime(entry.date.year, entry.date.month, entry.date.day);
      final normalizedSelectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      return entryDate.isAtSameMomentAs(normalizedSelectedDate); // Match only the date part
    })
        .toList();

    if (entriesForSelectedDate.isNotEmpty) {
      // Group entries by type
      final Map<String, List<dynamic>> groupedEntries = {};
      for (var entry in entriesForSelectedDate) {
        groupedEntries.putIfAbsent(entry.type, () => []).add(entry);
      }

      // Show entries in a dialog or new screen
      showDialog(
        context: context,
        builder: (context) => Container(
          child: AlertDialog(
            title: Text('Logs for ${formatDate(selectedDate)}'),
            content: Container(
              constraints: BoxConstraints(
                maxHeight: 200,
              ),
              child: Scrollbar( // Add the Scrollbar widget
                thumbVisibility: true,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: groupedEntries.entries.map((group) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            group.key, // Display type as a heading
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          ...group.value.map((entry) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${entry.details.toString().replaceAll('{', '').replaceAll('}', '')}'),
                                SizedBox(height: 8),
                              ],
                            );
                          }).toList(),
                          Divider(), // Add a divider between types
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Close'),
              ),
            ],
          ),
        ),
      );
    } else {
      // Show a message if no entries are found
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('No Logs for ${formatDate(selectedDate)}'),
          content: Text('You have no entries for this date.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        ),
      );
    }
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

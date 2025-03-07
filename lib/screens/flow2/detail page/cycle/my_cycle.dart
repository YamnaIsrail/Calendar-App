import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../admob/banner_ad.dart';
import '../../../../firebase/analytics/analytics_service.dart';
import 'edit_period.dart';

class MyCyclesScreen extends StatefulWidget {
  @override
  _MyCyclesScreenState createState() => _MyCyclesScreenState();
}

class _MyCyclesScreenState extends State<MyCyclesScreen> {
  // Variable to track selected filter
  String selectedFilter = 'All';
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now(); // Record the entry time
    AnalyticsService.logScreenView("My Cycles History");
  }

  @override
  void dispose() {
    if (_startTime != null) {
      int duration = DateTime.now().difference(_startTime!).inSeconds;
      AnalyticsService.logScreenTime("My Cycles History", duration);
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return bgContainer(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Cycles', style: TextStyle(color: Colors.black)),
        leading: CircleAvatar(
          backgroundColor: Color(0xffFFC4E8),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'My Cycles',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    CustomButton2(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CalendarScreen()),
                        );
                      },
                      backgroundColor: primaryColor,
                      text: "+ Add/Edit Periods",
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilterChip(
                      label: Text('All'),
                      selected: selectedFilter == 'All',
                      onSelected: (selected) {
                        setState(() {
                          selectedFilter = 'All';
                        });
                      },
                    ),
                    SizedBox(width: 8),
                    FilterChip(
                      label: Text('Period'),
                      selected: selectedFilter == 'Period',
                      onSelected: (selected) {
                        setState(() {
                          selectedFilter = 'Period';
                        });
                      },
                    ),
                    SizedBox(width: 8),
                    FilterChip(
                      label: Text('Ovulation'),
                      selected: selectedFilter == 'Ovulation',
                      onSelected: (selected) {
                        setState(() {
                          selectedFilter = 'Ovulation';
                        });
                      },
                    ),
                    SizedBox(width: 8),
                    FilterChip(
                      label: Text('Fertile'),
                      selected: selectedFilter == 'Fertile',
                      onSelected: (selected) {
                        setState(() {
                          selectedFilter = 'Fertile';
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Consumer<CycleProvider>(
                builder: (context, cycleProvider, child) {
                  List<Map<String, String>> pastPeriods =
                      cycleProvider.pastPeriods ?? [];

                  if (pastPeriods.isEmpty) {
                    return Text("No past periods available.");
                  }

                  List<DateTime> cycleStartDates = [];
                  List<DateTime> cycleEndDates = [];

                  // Convert string dates to DateTime and sort them
                  for (var period in pastPeriods) {
                    String? startDateString = period['startDate'];
                    String? endDateString = period['endDate'];

                    // Ensure both start and end dates are not null before processing
                    if (startDateString != null && endDateString != null) {
                      try {
                        DateTime startDate = DateTime.parse(startDateString);
                        DateTime endDate = DateTime.parse(endDateString);
                        cycleStartDates.add(startDate);
                        cycleEndDates.add(endDate);
                      } catch (e) {
                        // print("Invalid date format for period: $period");
                      }
                    } else {
                      // print("Missing start or end date for period: $period");
                    }
                  }

                  // Sort the cycles by start date
                  cycleStartDates
                      .sort((a, b) => a.compareTo(b)); // Oldest first
                  cycleEndDates.sort((a, b) => a.compareTo(b)); // Oldest first

                  // Calculate average cycle length and period length
                  int averageCycleLength =
                      _calculateAverageCycleLength(cycleStartDates).toInt();
                  int averagePeriodLength = _calculateAveragePeriodLength(
                          cycleStartDates, cycleEndDates)
                      .toInt();

                  // Group cycles by year
                  Map<int, List<int>> cyclesByYear = {};
                  for (int i = 0; i < cycleStartDates.length; i++) {
                    int year = cycleStartDates[i].year;
                    if (!cyclesByYear.containsKey(year)) {
                      cyclesByYear[year] = [];
                    }
                    cyclesByYear[year]!.add(i);
                  }

                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('History', style: TextStyle(fontSize: 16)),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    margin: EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.pink[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "$averageCycleLength Days",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "Average Cycle Length",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    margin: EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.yellow[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "$averagePeriodLength Days",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "Average Periods Length",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            // Display each year and its cycles
                            for (var year in cyclesByYear.keys)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    year.toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  for (var index in cyclesByYear[year]!)
                                    _buildCycleContainer(cycleStartDates,
                                        cycleEndDates, index, cycleProvider),
                                ],
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildLegend(),
                      SizedBox(height: 5),
                      BannerAdWidget(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildCycleContainer(List<DateTime> cycleStartDates,
      List<DateTime> cycleEndDates, int index, CycleProvider cycleProvider) {
    DateTime startDate = cycleStartDates[index];
    DateTime endDate = cycleEndDates[index];

    // Use next cycle's start date for the end of the current cycle
    DateTime nextStartDate = index < cycleStartDates.length - 1
        ? cycleStartDates[index + 1]
        : cycleProvider.getNextPeriodDate() ??
            DateTime
                .now(); // Use nextPeriodDate for the latest cycle, fallback to DateTime.now() if null

    // Calculate the cycle length
    int cycleLength = nextStartDate
        .difference(startDate)
        .inDays; // Days from start of this cycle to start of next cycle
    int periodLength = endDate.difference(startDate).inDays +
        1; // Days from start to end of this period

    // Calculate fertile and ovulation dates for each cycle
    List<DateTime> fertileDays = _calculateFertileDays(startDate, cycleLength);
    DateTime ovulationDay = _calculateOvulationDay(startDate, cycleLength);
    List<DateTime> periodDays = _calculatePeriodDays(startDate, endDate);

    // Create the progress bar for each cycle
    List<Widget> dayBars = [];
    for (int day = 0; day < cycleLength; day++) {
      DateTime currentDay = startDate.add(Duration(days: day));
      Color barColor =
          _getProgressColor(currentDay, fertileDays, ovulationDay, periodDays);

      // Only display the bar if it matches the selected filter
      if (_shouldDisplayDay(
          currentDay, fertileDays, ovulationDay, periodDays)) {
        dayBars.add(
          Expanded(
            flex: 1,
            child: Container(
              height: 8.0,
              color: barColor,
            ),
          ),
        );
      } else {
        // Add an invisible container to maintain layout
        dayBars.add(
          Expanded(
            flex: 1,
            child: Container(
              height: 8.0,
              color: Colors.transparent, // Invisible but maintains layout
            ),
          ),
        );
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.all(8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Cycle Start: ${startDate.toLocal().toString().split(' ')[0]}"),
          Row(
            children: dayBars,
          ),
          SizedBox(height: 5),
          Text(
              "Cycle Length: $cycleLength days, Period Length: $periodLength days"),
        ],
      ),
    );
  }

  bool _shouldDisplayDay(DateTime day, List<DateTime> fertileDays,
      DateTime ovulationDay, List<DateTime> periodDays) {
    if (selectedFilter == 'All') return true;
    if (selectedFilter == 'Period' && periodDays.contains(day)) return true;
    if (selectedFilter == 'Ovulation' && day.isAtSameMomentAs(ovulationDay))
      return true;
    if (selectedFilter == 'Fertile' && fertileDays.contains(day)) return true;
    return false;
  }

  num _calculateAverageCycleLength(List<DateTime> cycleStartDates) {
    if (cycleStartDates.length < 2) return CycleProvider().cycleLength;
    int totalDays = 0;
    for (int i = 1; i < cycleStartDates.length; i++) {
      totalDays += cycleStartDates[i].difference(cycleStartDates[i - 1]).inDays;
    }
    return totalDays / (cycleStartDates.length - 1);
  }

  double _calculateAveragePeriodLength(
      List<DateTime> cycleStartDates, List<DateTime> cycleEndDates) {
    if (cycleStartDates.isEmpty || cycleEndDates.isEmpty) return 0.0;
    int totalDays = 0;
    for (int i = 0; i < cycleEndDates.length; i++) {
      totalDays += cycleEndDates[i].difference(cycleStartDates[i]).inDays +
          1; // +1 to include the last day
    }
    return totalDays / cycleEndDates.length;
  }

  List<DateTime> _calculatePeriodDays(DateTime startDate, DateTime endDate) {
    List<DateTime> periodDays = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      periodDays.add(startDate.add(Duration(days: i)));
    }
    return periodDays;
  }

  Color _getProgressColor(DateTime day, List<DateTime> fertileDays,
      DateTime ovulationDay, List<DateTime> periodDays) {
    if (periodDays.contains(day)) {
      return Colors.red; // Period days
    } else if (fertileDays.contains(day) &&
        !day.isAtSameMomentAs(ovulationDay)) {
      return Colors.yellow; // Fertile days
    } else if (day.isAtSameMomentAs(ovulationDay)) {
      return Colors.orange; // Ovulation day
    } else {
      return Colors.grey[300] ?? Colors.grey; // Default color for other days
    }
  }

  List<DateTime> _calculateFertileDays(DateTime startDate, int cycleLength) {
    int ovulationOffset = cycleLength - 14;
    DateTime ovulationDate = startDate.add(Duration(days: ovulationOffset));

    List<DateTime> fertileDays = [];
    for (int i = -5; i <= 0; i++) {
      fertileDays.add(ovulationDate.add(Duration(days: i)));
    }

    return fertileDays;
  }

  DateTime _calculateOvulationDay(DateTime startDate, int cycleLength) {
    return startDate.add(Duration(days: cycleLength - 14));
  }

  Widget _buildLegend() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLegendItem(Colors.red, "Period Days"),
          _buildLegendItem(Colors.yellow, "Fertile Days"),
          _buildLegendItem(Colors.orange, "Ovulation Day"),
          _buildLegendItem(Colors.grey[300] ?? Colors.grey, "Other Days"),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}

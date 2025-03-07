import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../admob/ad_service.dart';
class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _hoveredDate; // For visual feedback when hovering
  final AdManager _adManager = AdManager();
  bool _isLoading = false; // Track loading indicator
  bool _isAdLoading = true; // Track ad loading separately

  List<Map<String, String>> _tempPeriods = []; // Temporary list of periods

  @override
  void initState() {
    super.initState();
    _adManager.loadInterstitialAd(
          () {
        setState(() {
          _isAdLoading = false; // Ad loaded successfully
        });
      },
          () {
        setState(() {
          _isAdLoading = false; // Ad failed to load
        });
      },
    );
    final cycleProvider = Provider.of<CycleProvider>(context, listen: false);
    _tempPeriods = List<Map<String, String>>.from(cycleProvider.pastPeriods).toList(); // Ensure it's mutable
     }

  @override
  void dispose() {
    _adManager.dispose();
    super.dispose();
  }

  void _saveAndShowAd() {

    setState(() {
      _isLoading = true; // Show loading indicator while saving
    });

    final cycleProvider = Provider.of<CycleProvider>(context, listen: false);
    // print("Temp Periods before saving: $_tempPeriods");
    cycleProvider.setPastPeriods(List<Map<String, String>>.from(_tempPeriods));

    if (_adManager.isAdLoaded()) {
      _adManager.showInterstitialAd(context, () {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context); // No ad, just navigate
    }
  }

  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<CycleProvider>(context);

    void _onDateClicked(DateTime clickedDate) {
      int periodLength = cycleProvider.periodLength;
      // Ensure no duplicate start dates in _tempPeriods
      _tempPeriods.removeWhere((period) =>
          DateTime.parse(period['startDate']!).isAtSameMomentAs(clickedDate));

      // Check if the date is already part of an existing period
      bool dateFound = false;
      for (var period in _tempPeriods) {
        final startDate = DateTime.parse(period['startDate']!);
        final endDate = DateTime.parse(period['endDate']!);
        // Handle clicking on marked dates (within the period)
        if (!clickedDate.isBefore(startDate) && !clickedDate.isAfter(endDate)) {
          dateFound = true;

          if (clickedDate.isAtSameMomentAs(startDate ) ||
              clickedDate.isAtSameMomentAs(endDate)) {
            // Remove the entire period if the start or end date is clicked
            setState(() {
              _tempPeriods.remove(period);
            });
          } else {
            // Adjust start or end date based on proximity
            final isCloserToStart =
                clickedDate.difference(startDate).abs() <
                    clickedDate.difference(endDate).abs();

            if (isCloserToStart) {
              // Update start date
              DateTime newStartDate = clickedDate.add(Duration(days: 1));
              setState(() {
                period['startDate'] = newStartDate.toIso8601String();
                // Update end date based on the new start date and period length
                period['endDate'] = newStartDate.add(Duration(days: periodLength - 1)).toIso8601String();
              });
            } else {
              // Update end date
              DateTime newEndDate = clickedDate.subtract(Duration(days: 1));
              setState(() {
                period['endDate'] = newEndDate.toIso8601String();
              });
            }
          }
          break;
        }

        // Handle clicking on unmarked dates within 5 days of an existing period
        if (clickedDate.isBefore(startDate) &&
            startDate.difference(clickedDate).inDays <= 5) {
          dateFound = true;
          setState(() {
            period['startDate'] = clickedDate.toIso8601String();
            // Update end date based on the new start date and period length
            period['endDate'] = clickedDate.add(Duration(days: periodLength - 1)).toIso8601String();
          });
          break;
        } else if (clickedDate.isAfter(endDate) &&
            clickedDate.difference(endDate).inDays <= 5) {
          dateFound = true;
          setState(() {
            period['endDate'] = clickedDate.toIso8601String();
          });
          break;
        }
      }

      if (!dateFound) {
        // Check if a period with the same start date already exists
        bool exists = _tempPeriods.any((period) {
          return DateTime.parse(period['startDate']!).isAtSameMomentAs(clickedDate);
        });

        if (!exists) {
          // Create a new period with a dynamic length based on the provider
          DateTime newEndDate = clickedDate.add(Duration(days: periodLength - 1)); // Use the period length
          setState(() {
            _tempPeriods.add({
              'startDate': clickedDate.toIso8601String(),
              'endDate': newEndDate.toIso8601String(),
            });
          });
        }
      }

      // Update the focused day to the clicked date
      setState(() {
        _focusedDay = clickedDate;
      });
    }
    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text('Edit Periods', style: TextStyle(color: Colors.black)),
          leading: CircleAvatar(
            backgroundColor: Color(0xffFFC4E8),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    onDaySelected: (selectedDay, focusedDay) {
                      _onDateClicked(selectedDay);
                    },
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, date, _) {
                        for (var period in _tempPeriods) {
                          final startDate = DateTime.parse(period['startDate']!);
                          final endDate = DateTime.parse(period['endDate']!);

                          if (date.isAtSameMomentAs(startDate)) {
                            return _buildCalendarCell(
                              date: date,
                              color: Colors.greenAccent,
                              border: Border.all(color: Colors.black, width: 2),
                            );
                          } else if (date.isAtSameMomentAs(endDate)) {
                            return _buildCalendarCell(
                              date: date,
                              color: Colors.redAccent,
                              border: Border.all(color: Colors.black, width: 2),
                            );
                          } else if (!date.isBefore(startDate) && !date.isAfter(endDate)) {
                            return _buildCalendarCell(date: date, color: Colors.pink);
                          }
                        }

                        return null;
                      },
                      todayBuilder: (context, date, _) {
                        return _buildCalendarCell(
                          date: date,
                          color: Colors.blue,
                          border: Border.all(color: Colors.black, width: 2),
                        );
                      },
                    ),

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                      style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor, foregroundColor: Colors.white),
                        onPressed: () {
                        _saveAndShowAd();
                        },
                        child: _isLoading ? CircularProgressIndicator() : Text("Save"),
                      ),
                      ElevatedButton(

                        style: ElevatedButton.styleFrom(
                            backgroundColor: secondaryColor),
                        onPressed: () {
                          // Discard changes
                          setState(() {
                            final cycleProvider =
                            Provider.of<CycleProvider>(context, listen: false);
                            _tempPeriods = List<Map<String, String>>.from(cycleProvider.pastPeriods);
                          });
                          Navigator.pop(context); // Close the screen
                        },
                        child: Text("Cancel"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3), // Semi-transparent background
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),


          ],
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
}

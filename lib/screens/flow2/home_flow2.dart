import 'dart:io';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:googleapis/connectors/v1.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../firebase/analytics/analytics_service.dart';
import '../../provider/cycle_provider.dart';
import '../settings/dialog.dart';
import '../../admob/banner_ad.dart';
import 'flow_2_screens_main/self_care.dart';
import 'flow_2_screens_main/analysis_main.dart';
import 'flow_2_screens_main/calendar.dart';
import 'flow_2_screens_main/my_cycle_main.dart';
import 'flow_2_screens_main/today.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Flow2Page extends StatefulWidget {
  @override
  _Flow2PageState createState() => _Flow2PageState();
}

class _Flow2PageState extends State<Flow2Page> {
  int _selectedIndex = 0;
  String _currentScreen = "Home"; // Track the current screen name
  DateTime _startTime = DateTime.now(); // Track screen time start

  final List<String> _screenNames = [
    "Home",
    "Calendar",
    "My Cycle",
    "Self Care",
    "Analysis"
  ];
  final List<Widget> _pages = [
    CycleStatusScreen(),
    CustomCalendar(),
    CycleTrackerScreen(),
    SelfCare(),
    Analysis(),
  ];
  @override
  void initState() {
    super.initState();
    _checkForRatingDialog();
    AnalyticsService.logScreenView(_screenNames[_selectedIndex]); // Log initial screen view
  }

  void _onItemTapped(int index) {
    int duration = DateTime.now().difference(_startTime).inSeconds;
    AnalyticsService.logScreenTime(_currentScreen, duration);

    setState(() {
      _selectedIndex = index;
      _currentScreen = _screenNames[index]; // Update current screen name
      _startTime = DateTime.now(); // Reset timer for new screen

    });
    AnalyticsService.logScreenView(_screenNames[index]);

    // Show rating dialog only when navigating to the first screen
    if (index == 0) {
      _checkForRatingDialog();
    }
  }

  Future<void> _checkForRatingDialog() async {
    final ratingBox = await Hive.openBox('ratingBox'); // Open the rating box
    int openCount = ratingBox.get('appOpenCount', defaultValue: 0);

    // If it's the 4th time opening the app, show the rating dialog
    if (openCount == 4) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        DialogHelper.showRatingPopup(context, (rating) {
          ratingBox.put('userRating', rating); // Store the rating if needed
        });
      });
      ratingBox.put('appOpenCount', openCount + 1);
    }
  }
  final List<String> _labels = [
    "Home",
    "Calendar",
    "My Cycle",
    "Self Care",
    "Analysis"
  ];
  final List<IconData> _icons = [
    Icons.home,
    Icons.calendar_today,
    Icons.female,
    Icons.favorite_border,
    Icons.bar_chart
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Exit App"),
            content: Text("Do you really want to exit the app?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () => exit(0),
                child: Text("Exit"),
              ),
            ],
          ),
        );
        return shouldExit ?? false;
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          bgContainer(child: Scaffold(
              backgroundColor: Colors.transparent,
              body: _pages[_selectedIndex],
              bottomNavigationBar: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  // BannerAdWidget(),
                  // SizedBox(height: 12), // Add some space between the banner and the navigation bar

                  CurvedNavigationBar(
                    index: _selectedIndex,
                    height: 65,
                    color: Colors.white,
                    buttonBackgroundColor: Color(0xFFEB1D98),
                    backgroundColor: Colors.transparent,
                    animationDuration: Duration(milliseconds: 300),
                    onTap: _onItemTapped,

                    items: _icons
                        .map((icon) => Icon(icon, size: 30, color: Colors.black))
                        .toList(),
                  ),
                ],
              ),
            )),
          Positioned(
            bottom: 6, // Adjust for proper positioning
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_labels.length, (index) {
                return Expanded(
                  // Ensures each label aligns with its icon
                  child: Column(
                    children: [
                      SizedBox(height: 30), // Matches icon's vertical space
                      Text(
                        _selectedIndex == index ? _labels[index] : "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          decoration:
                              TextDecoration.none, // Disable any underline
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    int duration = DateTime.now().difference(_startTime).inSeconds;
    AnalyticsService.logScreenTime(_currentScreen, duration); // Log last screen time
    super.dispose();
  }

}

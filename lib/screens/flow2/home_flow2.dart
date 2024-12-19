import 'dart:io';

import 'package:calender_app/firebase/user_session.dart';
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'detail page/self_care/foot.dart';
import 'flow_2_screens_main/self_care.dart';
import 'flow_2_screens_main/analysis_main.dart';
import 'flow_2_screens_main/calendar.dart';
import 'flow_2_screens_main/my_cycle_main.dart';
import 'flow_2_screens_main/today.dart';


class Flow2Page extends StatefulWidget {
  @override
  _Flow2PageState createState() => _Flow2PageState();
}

class _Flow2PageState extends State<Flow2Page> {
  int _selectedIndex = 0;
  bool isLoggedIn = false;

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
   // _checkLoginStatus(); // Check if the user is logged in
  }

  //  Future<void> _checkLoginStatus() async {
  //   bool loggedIn = await SessionManager.checkUserLoginStatus();
  //   setState(() {
  //     isLoggedIn = loggedIn;
  //   });
  //
  //   if (isLoggedIn) {
  //     await CycleProvider().saveCycleDataToFirestore();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: () async {
      // Show a confirmation dialog before exiting
      final shouldExit = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Exit App"),
          content: Text("Do you really want to exit the app?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Stay in app
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => exit(0), // Exit the app
              child: Text("Exit"),
            ),
          ],
        ),
      );
      return shouldExit ?? false; // Return false if dialog is dismissed
    },
      child: Scaffold(
        body: _pages.isNotEmpty ? _pages[_selectedIndex] : Center(child: CircularProgressIndicator()), // Display the selected page
        bottomNavigationBar: CurvedNavigationBar(
          index: 0, // Default active index
          height: 60.0,
          backgroundColor: Colors.white, // Background behind the nav bar
          color: Color(0xFFEB1D98), // Pink color as per your design
          animationDuration: Duration(milliseconds: 300),
          animationCurve: Curves.easeInOut,
          items: <Widget>[
            Icon(Icons.home, size: 30, color: Colors.white),
            Icon(Icons.calendar_today, size: 30, color: Colors.white),
            Icon(Icons.female, size: 30, color: Colors.white),
            Icon(Icons.favorite, size: 30, color: Colors.white),
            Icon(Icons.bar_chart, size: 30, color: Colors.white),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index; // Update the selected index
            });
          },
        ),
      ),
    );
  }
}

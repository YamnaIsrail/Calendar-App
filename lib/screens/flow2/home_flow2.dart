import 'package:calender_app/firebase/user_session.dart';
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
  String? userImageUrl; // To store the user's image URL
  bool isLoggedIn = false;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Check if the user is logged in
  }

  // Check if user is logged in and get user data
  Future<void> _checkLoginStatus() async {
    bool loggedIn = await SessionManager.checkUserLoginStatus();
    setState(() {
      isLoggedIn = loggedIn;
    });

    if (isLoggedIn) {
      // Retrieve the user ID and image URL
      String? userId = await SessionManager.getUserId();
      // Fetch image URL from Google Sign-In (replace with actual logic)
      // For example:
      userImageUrl = "https://your-image-url.com/user_profile.jpg"; // Replace with the actual URL

      // Call saveToFirestore method to sync cycle data
      await SessionManager.saveToFirestore();

      // Rebuild the _pages list after login to pass the image URL
      setState(() {
        _pages.clear();
        _pages.add(CycleStatusScreen(userImageUrl: userImageUrl));
        _pages.add(CustomCalendar());
        _pages.add(CycleTrackerScreen(userImageUrl: userImageUrl));
        _pages.add(SelfCare());
        _pages.add(Analysis());
      });
    } else {
      // Handle when user is not logged in
      // Show login page or navigate as necessary
      print("User is not logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}

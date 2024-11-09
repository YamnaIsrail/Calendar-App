import 'package:calender_app/screens/flow2/today.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'analysis.dart';
import 'calendar.dart';
import 'my_cycle.dart';


class Flow2Page extends StatefulWidget {
  @override
  _Flow2PageState createState() => _Flow2PageState();
}

class _Flow2PageState extends State<Flow2Page> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    CycleStatusScreen(),
    CustomCalendar(),
    CycleTrackerScreen(),
    HeartScreen(),
    Analysis(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
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

class HeartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Heart Page',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}


import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'partner_mode_calendar.dart';
import 'partner_mode_today.dart';

class HomePartnerFlow extends StatefulWidget {
  const HomePartnerFlow({super.key});

  @override
  State<HomePartnerFlow> createState() => _HomePartnerFlowState();
}

class _HomePartnerFlowState extends State<HomePartnerFlow> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    PregnancyStatusScreen(),
    PartnerModeCalendar(),
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

import 'dart:io';

import 'package:calender_app/provider/cycle_provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  void initState() {
    super.initState();
    // Access PartnerProvider and call _initializeCycleData method to initialize the cycle data
    final partnerProvider = Provider.of<PartnerProvider>(context, listen: false);
    partnerProvider.initializeCycleData(); // Call the provider method to initialize data
  }

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
      ),
    );
  }
}

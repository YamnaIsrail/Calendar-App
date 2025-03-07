import 'dart:io';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/provider/partner_provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../firebase/analytics/analytics_service.dart';
import 'partner_mode_calendar.dart';
import 'partner_mode_today.dart';

class HomePartnerFlow extends StatefulWidget {
  const HomePartnerFlow({super.key});

  @override
  State<HomePartnerFlow> createState() => _HomePartnerFlowState();
}

class _HomePartnerFlowState extends State<HomePartnerFlow> {
  int _selectedIndex = 0;
  DateTime? _startTime;

  final List<Widget> _pages = [
    PartnerStatusScreen(),
    PartnerModeCalendar(),
  ];

  final List<String> _labels = [
    "Home",
    "Calendar",
  ];

  final List<IconData> _icons = [
    Icons.home,
    Icons.calendar_today,
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    AnalyticsService.logScreenView(_labels[index]);

  }

  @override
  void initState() {
    super.initState();
    // Access PartnerProvider and call _initializeCycleData method to initialize the cycle data
    final partnerProvider = Provider.of<PartnerProvider>(context, listen: false);
    partnerProvider.initializeCycleData();

    _startTime = DateTime.now(); // Set start
    AnalyticsService.logScreenView(_labels[_selectedIndex]);
    }
  @override
  void dispose() {
    final duration = DateTime.now().difference(_startTime!);
    AnalyticsService.logScreenTime(_labels[_selectedIndex], duration as int);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
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
}


import 'package:calender_app/screens/homeScreen.dart';
import 'package:calender_app/screens/splash.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(CalenderApp());
}

class CalenderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' Tracking App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFE02E99),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: HomeScreen(),
    );
  }
}

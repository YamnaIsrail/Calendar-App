
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/screens/homeScreen.dart';
import 'package:calender_app/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:menstrual_cycle_widget/menstrual_cycle_widget_base.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MenstrualCycleWidget.init(
    secretKey: "11a1215l0119a140409p0919",
    ivKey: "23a1dfr5lyhd9a1404845001",
  );
  initializeDateFormatting().then((_) =>
      runApp(CalenderApp())
  );
}

class CalenderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => HomeScreen(),
      },

      title: ' Tracking App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: SplashScreen(),
    );
  }
}

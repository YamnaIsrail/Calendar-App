
import 'package:calender_app/provider/app_state_provider.dart';
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/provider/intercourse_provider.dart';
import 'package:calender_app/provider/notes_provider.dart';
import 'package:calender_app/provider/preg_provider.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/screens/homeScreen.dart';
import 'package:calender_app/screens/splash.dart';
import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:menstrual_cycle_widget/menstrual_cycle_widget_base.dart';

import 'hive/notes_model.dart';
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   MenstrualCycleWidget.init(
//     secretKey: "11a1215l0119a140409p0919",
//     ivKey: "23a1dfr5lyhd9a1404845001",
//   );
//   initializeDateFormatting().then((_) =>
//       runApp(CalenderApp())
//   );
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notesBox');

  // WidgetsFlutterBinding.ensureInitialized();
  // MenstrualCycleWidget.init(
  //     secretKey: "11a1215l0119a140409p0919",
  //     ivKey: "23a1dfr5lyhd9a1404845001"
  // );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CycleProvider()),
        ChangeNotifierProvider(create: (_) => PregnancyProvider()),
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ChangeNotifierProvider(create: (_) => IntercourseProvider()),

        ChangeNotifierProvider(create: (_) => NoteProvider()),
      ],
      child: CalenderApp(), // `child` is required here
    ),
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

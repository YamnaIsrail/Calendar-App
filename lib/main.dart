import 'package:calender_app/notifications/notification_service.dart';
import 'package:calender_app/provider/analysis/temperature_provider.dart';
import 'package:calender_app/provider/app_state_provider.dart';
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/provider/intercourse_provider.dart';
import 'package:calender_app/provider/moods_symptoms_provider.dart';
import 'package:calender_app/provider/notes_provider.dart';
import 'package:calender_app/provider/partner_mode_provider.dart';
import 'package:calender_app/screens/flow2/detail%20page/analysis/timeline/time_line_providers.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/screens/homeScreen.dart';
import 'package:calender_app/screens/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_option.dart';
import 'hive/cycle_model.dart';
import 'hive/notes_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'notifications/notification_storage.dart';
import 'provider/analysis/temperature_model.dart';
import 'provider/analysis/weight_provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.init();
  tz.initializeTimeZones();

  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notesBox');

  // Open the box for partner codes
  await Hive.openBox('partner_codes');

  await NotificationStorage.init();

  Hive.registerAdapter(CycleDataAdapter());
  // Open the box where you will store the cycle data
  await Hive.openBox<CycleData>('cycleData');


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CycleProvider()),
        ChangeNotifierProvider(create: (_) => PartnerProvider()),
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ChangeNotifierProvider(create: (_) => IntercourseProvider()),
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(create: (_) => WeightProvider()),
        ChangeNotifierProvider(create: (_) => TemperatureProvider()),
        ChangeNotifierProvider(create: (_) => MoodsProvider()),
        ChangeNotifierProvider(create: (_) => SymptomsProvider()),
        ChangeNotifierProvider(create: (_) => PartnerModeProvider()),
        ChangeNotifierProvider(create: (_) => TimelineProvider(
            noteProvider: NoteProvider(),
            symptomsProvider: SymptomsProvider(),
            moodsProvider: MoodsProvider()
        )
        ),



      ],
      child: CalenderApp(),
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
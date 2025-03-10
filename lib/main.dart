import 'package:calender_app/provider/date_day_format.dart';
import 'package:calender_app/provider/preg_provider.dart';
import 'package:calender_app/provider/showhide.dart';
import 'package:calender_app/screens/flow2/detail%20page/self_care/left_foot.dart';
import 'package:calender_app/screens/flow2/home_flow2.dart';
import 'package:calender_app/screens/settings/auth/password/enter_password.dart';
import 'package:calender_app/screens/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:calender_app/notifications/notification_service.dart';
import 'package:calender_app/provider/analysis/temperature_provider.dart';
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/provider/intercourse_provider.dart';
import 'package:calender_app/provider/moods_symptoms_provider.dart';
import 'package:calender_app/provider/notes_provider.dart';
import 'package:calender_app/provider/partner_mode_provider.dart';
import 'package:calender_app/screens/flow2/detail%20page/analysis/timeline/time_line_providers.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/screens/homeScreen.dart';
import 'package:periodtracker/screens/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'auth/auth_model.dart';
import 'auth/auth_provider.dart';
import 'firebase_option.dart';
import 'hive/cycle_model.dart';
import 'hive/notes_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'hive/partner_model.dart';
import 'hive/pets_services.dart';
import 'hive/timeline_entry.dart';
import 'kegel_excercise/kegel_excercises_pro/kegelDaysUnlocked_hive.dart';
import 'notifications/notification_model.dart';
import 'notifications/notification_storage.dart';
import 'provider/analysis/weight_provider.dart';

import 'package:calender_app/provider/partner_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MobileAds.instance.initialize();
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      testDeviceIds: [
        "e6a9c878-a931-409d-ac41-51276adfe273",
        "70c5122e-5518-4010-a78a-4f778409eba6",
        ],
    ),
  );
  await NotificationService.init();

  await Hive.initFlutter();

  // Register Hive Adapters
  Hive.registerAdapter(AuthDataAdapter());
  Hive.registerAdapter(TimelineEntryAdapter());
  Hive.registerAdapter(PartnerDataAdapter());
  Hive.registerAdapter(CycleDataAdapter());
  Hive.registerAdapter(NotificationModelAdapter());
  Hive.registerAdapter(NoteAdapter());

  // Open necessary boxes
  final authBox = await Hive.openBox<AuthData>('authBox');
  final authData = authBox.get('authData', defaultValue: AuthData())!;
  final ratingBox = await Hive.openBox('ratingBox');

  // Get the current app open count
  int openCount = ratingBox.get('appOpenCount', defaultValue: 0);

  // Increment the count
  openCount += 1;
  ratingBox.put('appOpenCount', openCount);

  await Future.wait([

    Hive.openBox('kegel_storage'),

    Hive.openBox('partner_codes'),
    Hive.openBox('timeBox'),
    Hive.openBox<Note>('notesBox'),
    Hive.openBox('temperatureBox'),
    Hive.openBox('backupSettings'),
    Hive.openBox<NotificationModel>('notifications'),
    Hive.openBox<CycleData>('cycleData'),
    Hive.openBox('partnerCycleData'),
    Hive.openBox('luteal_data'),
    Hive.openBox<TimelineEntry>('timelineBox'),
    Hive.openBox<Map>('medicineReminders'),
    Hive.openBox('formatsettingsBox'),
    Hive.openBox('settingsBox'),
    Hive.openBox('reminderBox'),
    HiveService.init(),// Ensures default pet is set
    Hive.openBox('visibleMoods'),
    Hive.openBox('visibleSymptoms'),
    Hive.openBox('weightBox'),
   KegelStorage.init(),

  ]);

  await CycleProvider().loadCycleDataFromHive();

  tz.initializeTimeZones();

  // Initialize providers
  final showHideProvider = ShowHideProvider();
  await showHideProvider.initialize();

  final pregnancyModeProvider = PregnancyModeProvider();
  await pregnancyModeProvider.initHive();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CycleProvider()),
        ChangeNotifierProvider.value(value: showHideProvider),
        ChangeNotifierProvider(create: (_) => PartnerProvider()),
        ChangeNotifierProvider.value(value: pregnancyModeProvider),
        ChangeNotifierProvider(create: (_) => IntercourseProvider()),
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(create: (_) => WeightProvider()),
        ChangeNotifierProvider(create: (_) => TemperatureProvider()),
        ChangeNotifierProvider(create: (_) => MoodsProvider()),
        ChangeNotifierProvider(create: (_) => SymptomsProvider()),
        ChangeNotifierProvider(create: (_) => PartnerModeProvider()),
        ChangeNotifierProvider(create: (_) => TimelineProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SettingsModel()),
      ],
      child: CalenderApp(),
    ),
  );
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// final GlobalKey<_Flow2PageState> flow2PageKey = GlobalKey<_Flow2PageState>();

class CalenderApp extends StatefulWidget {
  @override
  _CalenderAppState createState() => _CalenderAppState();
}

class _CalenderAppState extends State<CalenderApp> {
  @override
  void initState() {
    super.initState();

    _initializeCycleProvider();
    Provider.of<IntercourseProvider>(context, listen: false).loadData();
  }

  void _initializeCycleProvider() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cycleProvider = Provider.of<CycleProvider>(context, listen: false);
      cycleProvider.initialize(context);
    });
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
    navigatorKey: navigatorKey,
    title: 'Tracking App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
       home: SplashScreen(),
      routes: {
    '/login': (context) => EnterPasswordScreen(),
    '/home': (context) => HomeScreen(),
    '/flow2Home': (context) => Flow2Page(),
    '/foot': (context) => LeftFoot(),
        '/settings': (context) => SettingsPage(),

      },
    );
  }
}
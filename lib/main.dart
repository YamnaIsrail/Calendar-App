// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:calender_app/provider/date_day_format.dart';
import 'package:calender_app/provider/preg_provider.dart';
import 'package:calender_app/provider/showhide.dart';
import 'package:calender_app/screens/settings/auth/password/enter_password.dart';
import 'package:calender_app/screens/settings/language_option.dart';
import 'package:calender_app/screens/settings/translation.dart';
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
import 'package:calender_app/screens/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:translator/translator.dart';
import 'auth/auth_model.dart';
import 'auth/auth_provider.dart';
import 'firebase_option.dart';
import 'hive/cycle_model.dart';
import 'hive/notes_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'hive/partner_model.dart';
import 'hive/timeline_entry.dart';
import 'notifications/notification_model.dart';
import 'notifications/notification_storage.dart';
import 'provider/analysis/weight_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(AuthDataAdapter());

  // Open the authBox
  final authBox = await Hive.openBox<AuthData>('authBox');
  final authData = authBox.get('authData', defaultValue: AuthData())!;
  await Hive.openBox('partner_codes');

  tz.initializeTimeZones();

  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notesBox');
  await Hive.openBox('temperatureBox'); // Open Hive box to store temperatures

  // await NotificationStorage.init();
  var box = await Hive.openBox('myBox');
  Hive.registerAdapter(NotificationModelAdapter());

  await Hive.openBox<NotificationModel>('notifications');

  Hive.registerAdapter(CycleDataAdapter());
  await Hive.openBox<CycleData>('cycleData');

  Hive.registerAdapter(PartnerDataAdapter());
  await Hive.openBox('partnerCycleData');

  await CycleProvider().loadCycleDataFromHive();
  Hive.registerAdapter(TimelineEntryAdapter()); // Register Hive Adapter
  await Hive.openBox<TimelineEntry>('timelineBox');
  await Hive.openBox<Map>('medicineReminders'); // Box to store reminders

  await Hive.openBox('formatsettingsBox');

  await Hive.openBox<AuthData>('authBox');
  final showHideProvider = ShowHideProvider();
  await showHideProvider.initialize();

  await Hive.openBox('visibleSymptoms'); // Box for visible symptoms
  await Hive.openBox('visibleMoods'); // Box for visible moods

  runApp(
    MultiProvider(
      providers: [

        ChangeNotifierProvider(create: (_) => CycleProvider()),
        ChangeNotifierProvider.value(value: showHideProvider),
        ChangeNotifierProvider(create: (_) => PartnerProvider()),
        ChangeNotifierProvider(create: (_) => PregnancyModeProvider()),
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
        // Add the AuthProvider here
      ],
      child: CalenderApp(),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class CalenderApp extends StatefulWidget {
  @override
  _CalenderAppState createState() => _CalenderAppState();
}

class _CalenderAppState extends State<CalenderApp> {
  String _selectedLanguage = 'English'; // Default language
  final DynamicTranslation _dynamicTranslation = DynamicTranslation();
  Map<String, String> _localizedStrings = {};

  void _loadLanguage() async {
    final languageBox = await Hive.openBox('settingsBox');

    final savedLanguage = languageBox.get('language', defaultValue: 'English');
    _changeLanguage(savedLanguage);
  }

  void _saveLanguage(String language) async {
    final languageBox = await Hive.openBox('settingsBox');
    await languageBox.put('language', language);
  }

  Future<void> _changeLanguage(String language) async {
    setState(() {
      _selectedLanguage = language;
    });

    final languageCode = _getLanguageCode(language);

    // Get the translated words for the selected language
    final translatedStrings = await _dynamicTranslation.translateStrings(AppStrings.words, languageCode);

    // Update UI with the translated words
    setState(() {
      _localizedStrings = translatedStrings;
    });

    _saveLanguage(language);
  }

  // Helper method to map language name to its code
  String _getLanguageCode(String language) {
    final languageCodeMap = {
      "English": "en",
      "Spanish": "es",
      "French": "fr",
      "German": "de",
      "Italian": "it",
      "Portuguese": "pt",
      "Russian": "ru",
      "Chinese (Simplified)": "zh-cn",
      "Chinese (Traditional)": "zh-tw",
      "Japanese": "ja",
      "Korean": "ko",
      "Hindi": "hi",
      "Arabic": "ar",
      "Turkish": "tr",
      "Dutch": "nl",
      "Urdu": "ur",
    };
    return languageCodeMap[language] ?? 'en'; // Default to English
  }

  @override
  void initState() {
    super.initState();
    _loadLanguage();
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
      locale: Locale(_getLanguageCode(_selectedLanguage)),
      home: SplashScreen(),
      routes: {
    '/login': (context) => EnterPasswordScreen(),
    '/home': (context) => HomeScreen(),

        '/languageSelection': (context) => LanguageSelectionScreen(
          onLanguageChanged: (language) {
            _changeLanguage(language);  // Update language when user selects a new language
          },
        ),

    },
    );
  }
}
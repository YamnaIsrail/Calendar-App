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
import 'notifications/notification_storage.dart';
import 'provider/analysis/temperature_model.dart';
import 'provider/analysis/weight_provider.dart';
import 'package:simplytranslate/simplytranslate.dart';

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
  Hive.registerAdapter(AuthDataAdapter());
  await Hive.openBox('partner_codes');
  await NotificationStorage.init();
  Hive.registerAdapter(CycleDataAdapter());
  await Hive.openBox<CycleData>('cycleData');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CycleProvider()),
        ChangeNotifierProvider(create: (_) => PartnerProvider()),
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
        )),
        ChangeNotifierProvider(create: (_) => AuthProvider()),  // Add the AuthProvider here
      ],
      child: CalenderApp(),
    ),
  );
}

class CalenderApp extends StatefulWidget {
  @override
  _CalenderAppState createState() => _CalenderAppState();
}

class _CalenderAppState extends State<CalenderApp> {
  String _selectedLanguage = 'English'; // Default language

  // Create an instance of the DynamicTranslation class
  final DynamicTranslation _dynamicTranslation = DynamicTranslation();

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  // Load language preference from Hive storage
  _loadLanguage() async {
    final languageBox = await Hive.openBox('settingsBox');
    final savedLanguage = languageBox.get('language', defaultValue: 'English');
    setState(() {
      _selectedLanguage = savedLanguage;
    });
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
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tracking App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      locale: Locale(_getLanguageCode(_selectedLanguage)),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tracking App'),
        ),
        body: FutureBuilder<String>(
          future: _dynamicTranslation.translateText('Hello, User', _getLanguageCode(_selectedLanguage)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error'));
            }
            // Translate and display dynamic content
            return Column(
              children: [
                Text(snapshot.data ?? 'Hello, User'),
                ElevatedButton(
                  onPressed: () {
                    // Translate the logout button dynamically
                    _dynamicTranslation.translateText('Logout', _getLanguageCode(_selectedLanguage)).then((translatedText) {
                      // Now update the button text dynamically
                      setState(() {
                        // Update text dynamically when clicked
                      });
                    });
                  },
                  child: Text('Logout'),  // This text will be translated dynamically
                ),
              ],
            );
          },
        ),
      ),

    );
  }
}


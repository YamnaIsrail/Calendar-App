import 'package:translator/translator.dart';

class DynamicTranslation {
  final translator = GoogleTranslator();

  Future<Map<String, String>> translateStrings(
      List<String> words, String targetLanguageCode) async {
    final Map<String, String> translatedStrings = {};

    try {
      for (var word in words) {
        final translated = await translator.translate(word, to: targetLanguageCode);
        translatedStrings[word] = translated.text;
      }
    } catch (e) {
      // Fallback to the original words in case of an error
      return Map.fromIterable(words, key: (item) => item, value: (item) => item);
    }

    return translatedStrings;
  }
}

class AppStrings {
  // Add words for translation
  static final List<String> words = [
    "Tracking App",
    "Welcome",
    "Login",
    "Logout",
    "Home",
    "Settings",
    "Select Language",
    "Something went wrong.",
    "Loading...",

    // Period and Pregnancy Tracking
    "Period Tracking",
    "Pregnancy Tracking",
    "Cycle Length",
    "Next Period",
    "Period Start Date",
    "Period End Date",
    "Ovulation Date",
    "Fertility Window",
    "Pregnancy Test Result",
    "Due Date",
    "Weeks Pregnant",
    "Baby's Name",

    // Weight Tracking
    "Weight Tracking",
    "Current Weight",
    "Target Weight",
    "Weight History",

    // Partner
    "Partner",
    "Partner Details",

    // Settings
    "Account Settings",
    "Privacy Settings",
    "Notification Settings",
    "Unit Settings",
    "Language Settings",
    "Theme Settings",

    // Additional Settings
    "Dark Mode",
    "Notifications Enabled",
    "Privacy Policy",
    "Terms of Service",
    "Are you sure you want to log out?",
  ];
}

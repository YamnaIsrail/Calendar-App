import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static DateTime? _startTime;  // Stores the screen start time

  /// Logs screen view when a user visits a screen
  static Future<void> logScreenView(String screenName) async {
    _startTime = DateTime.now(); // Set start time when screen loads
    await _analytics.logScreenView(
      screenName: screenName,
    );
  }

  /// Logs custom events (e.g., button clicks, user interactions)
  static Future<void> logEvent(String eventName, {Map<String, dynamic>? parameters}) async {
    await _analytics.logEvent(
      name: eventName,
      parameters: parameters?.map((key, value) => MapEntry(key, value as Object)),
    );
  }

  /// Logs time spent on a screen when the user exits
  static Future<void> logScreenTime(String screenName, int duration) async {
    if (duration > 0) {
      await _analytics.logEvent(
        name: "screen_time",
        parameters: {
          "screen_name": screenName,
          "time_spent": duration,
        },
      );
    }
  }
}

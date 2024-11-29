import 'package:hive/hive.dart';
import '../provider/cycle_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SessionManager {

  void onUserLogin(String userId) async {
    await storeUserSession(userId);

    // Call saveToFirestore to automatically sync cycle data
    await saveToFirestore();
    print("User logged in. Cycle data is now synced.");
  }

  // Store session information in Hive
  static Future<void> storeUserSession(String userId) async {
    final box = await Hive.openBox('user_session');
    await box.put('isLoggedIn', true);  // Mark the user as logged in
    await box.put('userId', userId);    // Store the user ID or other session data
  }

  // Check if the user is logged in by reading from Hive
  static Future<bool> checkUserLoginStatus() async {
    final box = await Hive.openBox('user_session');
    bool? isLoggedIn = box.get('isLoggedIn', defaultValue: false);
    return isLoggedIn ?? false;
  }

  // Logout the user and clear the session data
  static Future<void> logoutUser() async {
    final box = await Hive.openBox('user_session');
    await box.clear();  // Clear all session data
  }

  // Get the user ID from the session
  static Future<String?> getUserId() async {
    final box = await Hive.openBox('user_session');
    return box.get('userId');  // Retrieve user ID from session
  }

  // Save cycle data to Firestore (triggered after login)
  static Future<void> saveToFirestore() async {
     final cycleProvider = CycleProvider();  // Use the actual instance of CycleProvider
    DateTime lastPeriodStart = cycleProvider.lastPeriodStart;
    int cycleLength = cycleProvider.cycleLength;
    int periodLength = cycleProvider.periodLength;

    // Check if user is logged in
    if (await checkUserLoginStatus()) {
      try {
        String? userId = await getUserId(); // Get user ID from session
        if (userId != null) {
          CollectionReference cycles = FirebaseFirestore.instance.collection('cycles');
          await cycles.doc(userId).set({
            'cycleStartDate': lastPeriodStart.toString(),
            'cycleEndDate': lastPeriodStart.add(Duration(days: cycleLength)).toString(),
            'periodLength': periodLength,
            'cycleLength': cycleLength,
          }, SetOptions(merge: true)); // Merge to avoid overwriting data
          print("Cycle data saved to Firebase.");
        }
      } catch (e) {
        print("Error saving cycle data to Firebase: $e");
      }
    } else {
      print("User is not logged in. Cycle data will not be saved to Firebase.");
    }
  }
}

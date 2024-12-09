import 'package:hive/hive.dart';
import '../provider/cycle_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SessionManager {
  //
  // void onUserLogin(String userId) async {
  //   await storeUserSession(userId);
  //
  //   // After login, call the CycleProvider's method to sync cycle data
  //   CycleProvider cycleProvider = CycleProvider();
  //   await cycleProvider.saveCycleDataToFirestore();
  //   print("User logged in. Cycle data is now synced.");
  // }

  // Store session information in Hive
  static Future<void> storeUserSession(String userId) async {
    final box = await Hive.openBox('user_session');
    await box.put('isLoggedIn', true);
    await box.put('userId', userId);
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

}

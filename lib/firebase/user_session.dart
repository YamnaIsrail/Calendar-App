import 'package:hive/hive.dart';
import '../auth/auth_services.dart';
import '../provider/cycle_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SessionManager {

  // Store session information in Hive
  static Future<void> storeUserSession(String userId,String userName,String userProfileImage,) async {
    final box = await Hive.openBox('user_session');
    await box.put('isLoggedIn', true);
    await box.put('userId', userId);

    if (userName != null) {
      await box.put('userName', userName);
    }
    if (userProfileImage != null) {
      await box.put('userProfileImage', userProfileImage);
    }
  }

  // Retrieve user details
  static Future<String?> getUserName() async {
    final box = await Hive.openBox('user_session');
    return box.get('userName');
  }

  static Future<String?> getUserProfileImage() async {
    final box = await Hive.openBox('user_session');
    return box.get('userProfileImage');
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

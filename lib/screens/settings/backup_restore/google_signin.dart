// google_sign_in_service.dart
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

import '../../../firebase/user_session.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Handles the user Google Sign-In flow
  Future<bool> signInWithGoogle() async {
    try {
      // Check if user is already signed in
      GoogleSignInAccount? googleUser = _googleSignIn.currentUser;
      if (googleUser == null) {
        googleUser = await _googleSignIn.signIn();
      }

      if (googleUser == null) {
        return false; // User canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Store session after successful login
      await SessionManager.storeUserSession(userCredential.user?.uid ?? '');

      return true;
    } catch (e) {
      print('Google Sign-In Error: $e');
      return false;
    }
  }

  /// Logs out the user from Google
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
    await SessionManager.logoutUser();
  }
}

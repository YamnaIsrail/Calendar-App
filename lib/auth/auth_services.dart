import 'package:calender_app/firebase/user_session.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle(BuildContext context, Function(bool) onLoading) async {
    onLoading(true); // Start loading

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        await SessionManager.storeUserSession(userCredential.user?.uid ?? '',
         userCredential.user!.displayName ?? 'Unknown User',
          userCredential.user!.photoURL ?? '',
        );


      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign-in canceled by user')));
      }
    } catch (error) {
      print('Google Sign-In Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google Sign-In failed. Please try again.')));
    } finally {
      onLoading(false); // Stop loading
    }
  }
}

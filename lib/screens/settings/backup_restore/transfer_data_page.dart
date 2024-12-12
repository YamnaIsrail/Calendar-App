import 'package:calender_app/firebase/user_session.dart';
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class TransferDataPage extends StatelessWidget {
  final String transferTo;

  TransferDataPage({required this.transferTo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transfer Data"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: FutureBuilder<User?>(
            future: handleSignIn(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("An error occurred during sign-in");
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (snapshot.data == null)
                      Text("Please sign in to transfer your data.")
                    else
                      Column(
                        children: [
                          Text("Your data has been saved on your Google account."),
                          SizedBox(height: 10),
                          Text("Signed in as: ${FirebaseAuth.instance.currentUser?.email ?? 'No account'}"),
                          SizedBox(height: 20),
                          CustomButton(
                            backgroundColor: secondaryColor,
                            onPressed: () async {
                              await handleSignOut(context);
                            },
                           text: "Sign out and change account",
                            textColor: Colors.black,
                          ),
                          SizedBox(height: 20),
                          CustomButton(
                            backgroundColor: primaryColor,
                            onPressed: () async {
                              // Trigger cycle data transfer after successful sign-in
                              await Provider.of<CycleProvider>(context, listen: false)
                                  .saveCycleDataToFirestore();
                              Navigator.pop(context);  // Close the page after transfer
                            },
                          text: "Continue"
                          ),
                        ],
                      ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<User?> handleSignIn(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      // Check if the user is already signed in
      if (googleSignIn.currentUser != null) {
        // If signed in, just return the user
        return FirebaseAuth.instance.currentUser;
      }

      // Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return null; // User canceled sign-in
      }

      // Get the authentication credentials
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Authenticate with Firebase
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Store session after successful login
      await storeUserSession(userCredential.user!.uid);

      // Return the signed-in user
      return userCredential.user;
    } catch (e) {
      print("Error during Google Sign-In: $e");
      return null;
    }
  }

  Future<void> storeUserSession(String userId) async {
    await SessionManager.storeUserSession(userId);
  }

  Future<void> handleSignOut(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    // Clear session data on logout
    await SessionManager.logoutUser();
    // Optionally, redirect the user to the previous screen or show a message
    Navigator.pop(context);
  }
}

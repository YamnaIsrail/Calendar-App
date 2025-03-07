import 'package:calender_app/firebase/user_session.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../settings_page.dart';
import 'partner_link_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PartnerModeSignInScreen extends StatefulWidget {
  @override
  _PartnerModeSignInScreenState createState() =>
      _PartnerModeSignInScreenState();
}
class _PartnerModeSignInScreenState extends State<PartnerModeSignInScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkUserSession(); // Check for existing user session on initialization
  }

  Future<void> _checkUserSession() async {
    setState(() {
      _isLoading = true;
    });

    try {

      bool isLoggedIn = await SessionManager.checkUserLoginStatus();
      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PartnerLinkScreen()),
        );
         }
    } catch (error) {
      //print('Error checking user session: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        // Store user session
        await SessionManager.storeUserSession(userCredential.user?.uid ?? '',
          userCredential.user!.displayName ?? 'Unknown User',
          userCredential.user!.photoURL ?? '',

        );

        // Navigate to PartnerLinkScreen after successful sign-in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PartnerLinkScreen()),
        );
      } else {
        // User canceled the sign-in process
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-in canceled by user')),
        );
      }
    } catch (error) {
      // Handle any errors
      //print('Google Sign-In Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed. Please try again.')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return bgContainer(
      child:  WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SettingsPage()),
          );
          return false; // Prevent default back navigation
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              "Partner Mode",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Color(0xFFFFC4E8),
                    borderRadius: BorderRadius.circular(50)),
                child: Icon(Icons.arrow_back),
              ),
              onPressed: () =>   Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              ),
            ),

          ),
          body: Padding(
            padding: const EdgeInsets.all(35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/partner_mode/Isolation_Mode.svg"),
                SizedBox(height: 30),
                Text(
                  'A tap to cloud sync,\n'
                      'a step closer to partner',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Real-time cloud sync ensures a more '
                      'private and convenient experience for both of you. '
                      'To access it, please sign in first.',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                _isLoading
                    ? CircularProgressIndicator() // Show loading indicator when processing
                    : CustomButton(
                  onPressed: () => _handleGoogleSignIn(context),
                  text: "Sign in with Google",
                  backgroundColor: Colors.blueAccent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

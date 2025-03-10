import 'dart:async';
import 'package:calender_app/auth/auth_provider.dart';
import 'package:calender_app/provider/partner_provider.dart';
import 'package:calender_app/screens/partner_mode/partner_flow/home_partner_flow.dart';
import 'package:calender_app/screens/partner_mode/partner_flow/partner_mode_today.dart';
import 'package:calender_app/screens/settings/auth/password/enter_password.dart';
import 'package:calender_app/screens/settings/auth/password/enter_pin.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../hive/cycle_model.dart';
import 'flow2/home_flow2.dart';
import 'homeScreen.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showRipple = false;
  bool showHeart = false;
  bool showText = false;
  bool isLoading = true; // New loading state
  bool showCircularIndicator = false; // New state for circular indicator

  @override
  void initState() {
    super.initState();
    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    setState(() {
      showRipple = true;
    });
    await Future.delayed(Duration(milliseconds: 600));

    setState(() {
      showRipple = false;
      showHeart = true;
    });
    await Future.delayed(Duration(milliseconds: 600));

    setState(() {
      showHeart = false;
      showText = true;
    });
    await Future.delayed(Duration(milliseconds: 800));

    // Start a timer for 2 seconds
    await Future.delayed(Duration(milliseconds: 200));

    // Check if loading is still in progress
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    while (!authProvider.isInitialized) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    // Check if data exists
    bool hasCycleData = await checkIfCycleDataExists();
    bool hasPartnerCycleData = await checkIfPartnerCycleDataExists();

    // Set loading to false after checking data
    setState(() {
      isLoading = false; // Loading is complete
      showCircularIndicator = !authProvider.isInitialized; // Show circular indicator if loading is not complete
    });

    // Navigate based on the data existence
    if (authProvider.hasPasswordOrPin) {
      if (authProvider.usePassword) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EnterPasswordScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EnterPinScreen()),
        );
      }
    } else {
      if (hasCycleData) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Flow2Page()),
        );
      } else if (hasPartnerCycleData) {
        final partnerProvider = Provider.of<PartnerProvider>(context, listen: false);
        await partnerProvider.listenForCycleUpdates();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePartnerFlow()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    }
  }

  Future<bool> checkIfCycleDataExists() async {
    var box = await Hive.openBox<CycleData>('cycleData');
    CycleData? cycleData = box.get('cycle');
    return cycleData != null;
  }

  Future<bool> checkIfPartnerCycleDataExists() async {
    try {
      var box = Hive.box('partnerCycleData');
      var partnerCycleData = box.get('partnerData');
      return partnerCycleData != null;
    } catch (e) {
      // print("Error accessing partnerCycleData box: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedOpacity(
                opacity: showRipple ? 1.0 : 0.0,
                duration: Duration(milliseconds: 300),
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  width: showRipple ? 208 : 0,
                  height: showRipple ? 58 : 0,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(215, 210, 210, 1.0),
                    borderRadius: BorderRadius.all(Radius.elliptical(208, 58)),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: showHeart ? 1.0 : 0.0,
                duration: Duration(milliseconds: 300),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 200),
                  child: Image.asset(
                    "assets/splash.png",
                    height: 126,
                    width: 126,
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 400),
                top: showText ? 150.0 : 300.0,
                child: AnimatedOpacity(
                  opacity: showText ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 400),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Period & Ovulation Tracker",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible, // Ensures text wraps instead of being cut off
                        textAlign: TextAlign.center, // Optional: Centers text

                      ),
                      if (showCircularIndicator) // Show circular indicator if needed
                        CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
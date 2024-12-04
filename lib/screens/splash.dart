import 'dart:async';
import 'package:calender_app/auth/auth_provider.dart';
import 'package:calender_app/screens/settings/auth/password/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'homeScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showRipple = false;
  bool showHeart = false;
  bool showText = false;

  @override
  void initState() {
    super.initState();
    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    setState(() {
      showRipple = true;
    });
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      showRipple = false;
      showHeart = true;
    });
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      showHeart = false;
      showText = true;
    });
    await Future.delayed(Duration(seconds: 3));

    // After animation, check for authentication and navigate accordingly
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.password != null || authProvider.pin != null) {
      // If password or PIN is set, go to the login screen
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Login()));
    } else {
      // If not set, go to the setup screen
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
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
                duration: Duration(seconds: 1),
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
                duration: Duration(seconds: 1),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 200),
                  child: Image.asset(
                    "assets/splash.png", height: 126, width: 126,
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: Duration(seconds: 1),
                top: showText ? 150.0 : 300.0,
                child: AnimatedOpacity(
                  opacity: showText ? 1.0 : 0.0,
                  duration: Duration(seconds: 1),
                  child: Text(
                    "My Calendar",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
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

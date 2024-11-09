import 'dart:async';
import 'package:flutter/material.dart';
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
    // Show ripple effect with animation
    setState(() {
      showRipple = true;
    });
    await Future.delayed(Duration(seconds: 3));

    // Show heart icon with animation
    setState(() {
      showRipple = false;
      showHeart = true;
    });
    await Future.delayed(Duration(seconds: 1));

    // Show text with animation
    setState(() {
      showHeart = false;
      showText = true;
    });
    await Future.delayed(Duration(seconds: 3));

    // Navigate to home screen
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8, // Set to a percentage of screen width

          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedOpacity(
                opacity: showRipple ? 1.0 : 0.0,
                duration: Duration(seconds: 1),
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  width: showRipple ? 208 : 0,  // Animate width
                  height: showRipple ? 58 : 0,   // Animate height
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(215, 210, 210, 1.0),
                    borderRadius: BorderRadius.all(Radius.elliptical(208, 58)),
                  ),
                ),
              ),

              // Heart Icon with fade-in animation
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

              // "My Calendar" Text with fade-in and position animation
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

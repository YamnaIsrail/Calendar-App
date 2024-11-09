import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child; // To allow other widgets to be placed on top of the background

  const BackgroundWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              top: -50,
              left: 160,
              child: Container(
                height: 200,
                width: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [
                    Color(0xFFEB1D98).withOpacity(0.5),
                    Color(0xFFffff).withOpacity(0.5),
                  ]),
                ),
              ),
            ),
            Positioned(
              bottom: 170,
              left: 160,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFE710).withOpacity(0.5),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: 160,
              child: Container(
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFAFD1F3).withOpacity(0.5),
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            child, // Place the child widget on top of the background
          ],
        ),
      ),
    );
  }
}

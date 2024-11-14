import 'package:flutter/material.dart';

class bgContainer extends StatelessWidget {
  final Widget child;
  const bgContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
        gradient: LinearGradient(
          colors: [
            Color(0xFFE8EAF6),
            Color(0xFFF3E5F5)
          ], // Light gradient background
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,

    );
  }
}

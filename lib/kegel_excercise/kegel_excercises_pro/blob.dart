import 'dart:math';

import 'package:flutter/material.dart';
class AnimatedBlob extends StatefulWidget {
  final String state;
  final String counter;

  AnimatedBlob({required this.state, required this.counter});

  @override
  _AnimatedBlobState createState() => _AnimatedBlobState();
}

class _AnimatedBlobState extends State<AnimatedBlob> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _sizeAnimation = Tween<double>(begin: 200, end: 250).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: -15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ClipPath(
            clipper: BlobClipper(),
            child: Transform.rotate(
              angle: _rotationAnimation.value * (pi / 180), // Convert degrees to radians
              child: Container(
                width: _sizeAnimation.value,
                height: _sizeAnimation.value,
                decoration: BoxDecoration(
                  color: Colors.white54,
                  gradient: RadialGradient(
                    colors: [Colors.purple.shade200, Colors.purple.shade700],
                    center: Alignment.center,
                    radius: 0.8,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.state,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      if (widget.counter.isNotEmpty) // Show counter only if it's not empty
                        SizedBox(height: 10),
                      if (widget.counter.isNotEmpty)
                        Text(
                          widget.counter,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class BlobClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.5, 0);
    path.quadraticBezierTo(size.width, 0, size.width, size.height * 0.5);
    path.quadraticBezierTo(size.width, size.height, size.width * 0.5, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height * 0.5);
    path.quadraticBezierTo(0, 0, size.width * 0.5, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

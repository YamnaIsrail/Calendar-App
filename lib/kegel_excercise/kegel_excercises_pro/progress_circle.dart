import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/animation.dart';

class CircleProgressPainter extends CustomPainter {
  final double progress;

  CircleProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Paint for the background circle (grey)
    Paint backgroundPaint = Paint()
      ..color = Colors.grey // Set the color to grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    // Paint for the progress arc (white)
    Paint progressPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    // Draw the background circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      backgroundPaint,
    );

    // Draw the progress arc
    double sweepAngle = 2 * pi * progress; // Calculate the sweep angle based on progress
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
      -pi / 2, // Start angle (top of the circle)
      sweepAngle, // Sweep angle based on the progress
      false, // Don't fill the arc, just stroke
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint when progress changes
  }
}
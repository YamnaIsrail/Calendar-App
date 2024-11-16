import 'package:flutter/material.dart';


class MultiColorProgressBar extends StatelessWidget {
  final double progress; // Progress value between 0 and 10

  MultiColorProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, 10),
      painter: ProgressBarPainter(progress: progress),
    );
  }
}

class ProgressBarPainter extends CustomPainter {
  final double progress;

  ProgressBarPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    double barWidth = size.width;

    // Set up paint for the progress bar sections
    Paint paint = Paint()..style = PaintingStyle.fill;

    // Draw sections with different colors
    double sectionWidth = barWidth * (progress / 10);

    // First color section (Blue)
    paint.color = Colors.blue;
    double firstSectionWidth = sectionWidth <= (barWidth * 0.5) ? sectionWidth : barWidth * 0.5;
    canvas.drawRect(Rect.fromLTRB(0, 0, firstSectionWidth, size.height), paint);

    // Second color section (Green)
    paint.color = Colors.green;
    double secondSectionWidth = sectionWidth > (barWidth * 0.5)
        ? sectionWidth - firstSectionWidth
        : 0;
    canvas.drawRect(Rect.fromLTRB(firstSectionWidth, 0, firstSectionWidth + secondSectionWidth, size.height), paint);

    // Third color section (Yellow)
    paint.color = Colors.yellow;
    double thirdSectionWidth = sectionWidth > (barWidth * 0.75)
        ? sectionWidth - firstSectionWidth - secondSectionWidth
        : 0;
    canvas.drawRect(Rect.fromLTRB(firstSectionWidth + secondSectionWidth, 0, firstSectionWidth + secondSectionWidth + thirdSectionWidth, size.height), paint);

    // Draw the background of the progress bar
    paint.color = Colors.grey[300]!;
    double remainingWidth = barWidth - sectionWidth;
    canvas.drawRect(
      Rect.fromLTRB(sectionWidth, 0, barWidth, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false; // No need to repaint as progress value remains constant.
  }
}

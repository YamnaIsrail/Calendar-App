import 'package:calender_app/provider/cycle_provider.dart';
import 'package:flutter/material.dart'; // For UI widgets and painting
import 'dart:math';

class DualProgress extends CustomPainter {
  final PartnerProvider partnerProvider;

  DualProgress({required this.partnerProvider});

  @override
  void paint(Canvas canvas, Size size) {
    final today = DateTime.now();
    final daysSinceLastPeriod = partnerProvider.getDaysUntilNextPeriod();
    final currentCycleDay = partnerProvider.cycleDay;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - 10;

    // Background Paint
    final backgroundPaint = Paint()
      ..color = const Color(0xFFE0E0E0) // Light gray
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Check if the period is late
    final expectedPeriodStart = partnerProvider.lastMenstrualPeriod!.add(Duration(days: partnerProvider.cycleLength!));
    final isPeriodLate = today.isAfter(expectedPeriodStart) && daysSinceLastPeriod >= partnerProvider.cycleLength!;

    final anglePerDay = 2 * pi / partnerProvider.cycleLength!;

    // Check if the period is late
    if (isPeriodLate) {
      // Draw the entire circle in dark red (indicating period is late)
      final latePeriodPaint = Paint()
        ..color = const Color(0xFFD72626) // Dark Red for late periods
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20;

      canvas.drawCircle(center, radius, latePeriodPaint);
      return; // Exit the painting as the entire circle is dark red
    }

    // Draw progress for current cycle
    for (int day = 1; day <= partnerProvider.cycleLength!; day++) {
      // Get the color for each day
      final paint = Paint()
        ..color = getDayColor(day, currentCycleDay, today)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20;

      drawArcForDay(canvas, day, center, radius, paint, anglePerDay);

      if (day == currentCycleDay) break; // Stop drawing after the current day
    }
  }

  // Function to determine the color of each day
  Color getDayColor(int day, int currentCycleDay, DateTime today) {
    final periodStartDay = 1; // Assuming period starts on the first day of the cycle
    final periodEndDay = partnerProvider.periodLength; // Period end day


    // Return colors for different conditions
    if (day <= 3 && day <= periodEndDay!) {
      return const Color(0xFFFF4D4D); // Bright Red for the first 3 days of the period
    }

    // After the first 3 days but within the period, use Warm Pink
    if (day > 3 && day <= periodEndDay!) {
      return const Color(0xFFFF6F91); // Warm Pink for the rest of the period
    }

    final daysUntilNextPeriod = partnerProvider.cycleLength! - currentCycleDay;
    return (daysUntilNextPeriod < 3)
        ? const Color(0xFF90CAF9) // Light Blue if period is near
        : const Color(0xFFA7E5A5); // Pastel Green for normal days
  }

  // Function to draw arc for each day
  void drawArcForDay(Canvas canvas, int day, Offset center, double radius, Paint paint, double anglePerDay) {
    final startAngle = -pi / 2 + (day - 1) * anglePerDay;
    final sweepAngle = anglePerDay;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant DualProgress oldDelegate) {
    return oldDelegate.partnerProvider.lastMenstrualPeriod != partnerProvider.lastMenstrualPeriod ||
        oldDelegate.partnerProvider.cycleLength != partnerProvider.cycleLength ||
        oldDelegate.partnerProvider.periodLength != partnerProvider.periodLength;
  }
}

class PregnancyProgress extends CustomPainter {
  final PartnerProvider partnerProvider;

  PregnancyProgress({required this.partnerProvider});

  @override
  void paint(Canvas canvas, Size size) {
    if (!partnerProvider.isPregnancyMode || partnerProvider.gestationStart == null) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - 10;

    final totalGestationDays = 280;
    final today = DateTime.now();
    final gestationStart = partnerProvider.gestationStart!;
    final elapsedDays = today.difference(gestationStart).inDays;
    final progress = elapsedDays / totalGestationDays;

    // Background Arc (gray)
    final backgroundPaint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress Arc
    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          const Color(0xFF4CAF50), // Green (early pregnancy)
          const Color(0xFFFFEB3B), // Yellow (mid pregnancy)
          const Color(0xFFF44336), // Red (late pregnancy)
        ],
        stops: [0.3, 0.7, 1.0],
        startAngle: 0.0,
        endAngle: 2 * pi,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;

    final sweepAngle = progress * 2 * pi; // Progress angle
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


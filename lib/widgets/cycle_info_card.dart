
import 'package:flutter/material.dart';
import 'dart:async';

class CustomProgressBar extends StatefulWidget {
  final double progress; // Target progress value (0 to 100)

  const CustomProgressBar({Key? key, required this.progress}) : super(key: key);

  @override
  _CustomProgressBarState createState() => _CustomProgressBarState();
}


class _CustomProgressBarState extends State<CustomProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 320,
        height: 10,
        decoration: BoxDecoration(
          color: Color(0xffe6e5e5), // Background color
          border: Border.all(color: Colors.grey, width: 0.5), // Border
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Container(
              width: (320 * widget.progress) / 100, // Progress width
              height: 20,
              decoration: BoxDecoration(
                color: Colors.pink, // Progress fill color
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Center(
              child: Text(
                "${widget.progress.toInt()}%", // Display the progress value
                style: TextStyle(
                  color: widget.progress < 44
                      ? Colors.pink
                      : widget.progress > 54
                      ? Colors.white
                      : Colors.black,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


Widget buildCycleInfoCard({
  required String title,
  required String subtitle,
  String? progressLabelStart,
  String? progressLabelEnd,
  double? progressValue,
  required IconData icon,
}) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 5,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.pink, size: 24),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        if (progressLabelStart != null)
          CustomProgressBar(
            progress: (progressValue ?? 0) * 100, // Convert to percentage
          ),
        if (progressLabelStart != null)
          SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (progressLabelStart != null) Text(progressLabelStart),
            if (progressLabelEnd != null) Text(progressLabelEnd),
          ],
        ),
      ],
    ),
  );
}

Widget buildPregnancyInfoCard({
  required String title,
  required String subtitle,
  required IconData icon,
}) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 5,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.pink, size: 24),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),

      ],
    ),
  );
}



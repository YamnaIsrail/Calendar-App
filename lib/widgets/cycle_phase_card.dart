import 'package:flutter/material.dart';

class CyclePhaseCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String phase;
  final String date;

  const CyclePhaseCard({
    Key? key,
    required this.icon,
    required this.color,
    required this.phase,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Add some padding for better layout
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Align text to the start
          children: [
            Text(
              phase,
              style: const TextStyle(fontWeight: FontWeight.bold), // Style for emphasis
            ),
            Text(date),
            Icon(icon),
          ],
        ),
      ),
    );
  }
}

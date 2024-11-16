import 'package:flutter/material.dart';

class SymptomsSection extends StatelessWidget {
  final List<String> symptoms;
  final String severity;

  SymptomsSection({required this.symptoms, required this.severity});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Possible Symptoms", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text("Severity: $severity"),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: symptoms.map((symptom) => Chip(label: Text(symptom))).toList(),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'cycle_phase_widgets/SymptomsSection.dart';
import 'cycle_phase_widgets/phase_info.dart';

class PhaseScreen extends StatelessWidget {
  final String phaseName;
  final String description;
  final Color color;
  final String imagePath;

  const PhaseScreen({
    required this.phaseName,
    required this.description,
    required this.color,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title: Text(phaseName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Top Section
          Column(
            children: [
              SvgPicture.asset(
                imagePath,
                height: 100,
                width: 100,
              ),
              SizedBox(height: 16),
              Text(
                phaseName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(height: 24),

          // Additional Sections (similar to PhaseInfo, SymptomsSection, etc.)
          PhaseInfo(
            title: "Menstrual Cramps Relief",
            content: "Menstrual cramps are a common issue...",
          ),
          SizedBox(height: 16),
          SymptomsSection(
            symptoms: ["Nausea", "Vomiting", "Cramping"],
            severity: "LOW",
          ),
          SizedBox(height: 16),

        ],
      ),
    );
  }
}

import 'period_phase.dart';
import 'package:flutter/material.dart';

import 'phase.dart';

class PeriodScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PhaseScreen(
      phaseName: "Period",
      description: "This phase marks the beginning of your menstrual cycle.",
      color: Colors.redAccent,
      imagePath: 'assets/images/period.png', // replace with actual path
    );
  }
}

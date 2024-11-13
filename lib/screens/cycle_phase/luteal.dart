import 'package:flutter/material.dart';

import 'phase.dart';
class LutealScreen extends StatelessWidget {
@override
Widget build(BuildContext context) {
  return PhaseScreen(
    phaseName: "Luteal",
    description: "This phase occurs after ovulation, leading up to your period.",
    color: Colors.purpleAccent,
    imagePath: 'assets/images/luteal.png', // replace with actual path
  );
}
}

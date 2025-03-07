import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/background.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'exercise_model.dart';
import 'pain_relief.dart';
import 'pose_3.dart';

class pose2 extends StatelessWidget {
  const pose2({super.key});

  @override
  Widget build(BuildContext context) {
    return ExerciseModel(
      title: 'Supported child’s pose',
      time: '03:00',
      imagePath: 'assets/self_care/pose1.png',
      goto: pose3(),
      onBackPress: painRelief(),

    );
  }
}


import 'exercise_model.dart';
import 'package:flutter/material.dart';
import 'pain_relief.dart';
import 'pose_2.dart';

class pose1 extends StatelessWidget {
  const pose1({super.key});

  @override
  Widget build(BuildContext context) {
    return ExerciseModel(
      title: 'Supported pigeon pose',
      time: '03:00',
      imagePath: 'assets/self_care/pose2.png',
      goto: pose2(),
      onBackPress: painRelief(),

    );
  }
}


import 'exercise_model.dart';
import 'package:flutter/material.dart';
import 'pain_relief.dart';
import 'welldone.dart';

class pose3 extends StatelessWidget {
  const pose3({super.key});

  @override
  Widget build(BuildContext context) {
    return ExerciseModel(
      title: 'Supported reclining \n bound angle pose',
      time: '03:00',
      imagePath: 'assets/self_care/pose3.png',
      goto: Welldone(sourceScreen: 'pose3'),
      onBackPress: painRelief(),

    );
  }
}

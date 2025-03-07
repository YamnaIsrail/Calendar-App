import 'exercise_model.dart';
import 'package:flutter/material.dart';
import 'foot.dart';
import 'welldone.dart';

class RightFoot extends StatelessWidget {
  const RightFoot({super.key});

  @override
  Widget build(BuildContext context) {
    return ExerciseModel(
        title: 'Right Foot Massage',
        time: '03:00',
        onBackPress: foot(),

        imagePath: 'assets/self_care/right_foot.png',
        goto:Welldone(sourceScreen: 'footExercise2')
    );
  }
}

import 'package:calender_app/screens/flow2/detail%20page/self_care/foot_excercise_1.dart';
import 'package:calender_app/screens/flow2/detail%20page/self_care/pose_1.dart';
import 'package:flutter/material.dart';

class FootExcercise2 extends StatelessWidget {
  const FootExcercise2({super.key});

  @override
  Widget build(BuildContext context) {
    return footExcercise(
      title: 'Right Foot Massage',
      time: '03:00',
      imagePath: 'assets/self_care/right_foot.png',
      goto: pose1()

    );
  }
}

import 'package:calender_app/screens/flow2/detail%20page/self_care/foot_excercise_1.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/background.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'pose_2.dart';

class pose1 extends StatelessWidget {
  const pose1({super.key});

  @override
  Widget build(BuildContext context) {
    return footExcercise(
      title: 'Supported pigeon pose',
      time: '03:00',
      imagePath: 'assets/self_care/pose2.png',
      goto: pose2(),

    );
  }
}

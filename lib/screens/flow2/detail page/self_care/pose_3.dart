import 'package:calender_app/screens/flow2/detail%20page/self_care/foot_excercise_1.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/background.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'welldone.dart';

class pose3 extends StatelessWidget {
  const pose3({super.key});

  @override
  Widget build(BuildContext context) {
    return footExcercise(
      title: 'Supported reclining \n bound angle pose',
      time: '03:00',
      imagePath: 'assets/self_care/pose3.png',
      goto: Welldone(),

    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class pic extends StatelessWidget {
  const pic({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset( 'assets/self_care/calm.png'),
            SvgPicture.asset('assets/self_care/sound.png')
          ],
        ),
      ),
    );
  }
}

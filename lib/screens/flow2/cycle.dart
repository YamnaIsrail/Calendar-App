import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class cycle extends StatelessWidget {
  const cycle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: SvgPicture.asset(
        "assets/emoji/9.svg", // This is the path to the SVG asset
        width: 40,
        height: 40,
      ),),
    )
    ;
  }
}

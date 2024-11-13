import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PhaseHeader extends StatelessWidget {
  final String iconPath;
  final String phaseName;
  final Widget? leftPage;
  final Widget? rightPage;

  PhaseHeader({
    required this.iconPath,
    required this.phaseName,
    this.leftPage,
    this.rightPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () {
            if (leftPage != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => leftPage!),
              );
            }
          },
          icon: Icon(Icons.arrow_left_outlined, size: 50),
        ),
        Column(
          children: [
            SvgPicture.asset(iconPath, height: 80, width: 80),
            SizedBox(height: 8),
            Text(
              phaseName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            if (rightPage != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => rightPage!),
              );
            }
          },
          icon: Icon(Icons.arrow_right, size: 50),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

TextStyle headingStyle = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 22,
);

TextStyle subHeadingStyle = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 18,
);

TextStyle bodyTextStyle = TextStyle(
  fontSize: 16,
);

Widget customSection( String subHeading, String bodyText, String imgpath) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(subHeading, style: subHeadingStyle),
      SizedBox(height: 5),
      Text(bodyText, style: bodyTextStyle),
      SizedBox(height: 10),
      Center(
        child: Image.asset(imgpath, height: 106, width: 106,)
      ),
      SizedBox(height: 10),
    ],
  );
}

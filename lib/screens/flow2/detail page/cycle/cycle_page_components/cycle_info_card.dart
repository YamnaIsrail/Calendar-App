import 'package:calender_app/widgets/contain.dart';
import 'package:calender_app/widgets/cycle_info_card.dart';
import 'package:flutter/material.dart';

class CycleInfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String progressLabelStart;
  final String progressLabelEnd;
  final double progressValue;
  Function click;

   CycleInfoCard({
    required this.title,
    required this.subtitle,
    required this.progressLabelStart,
    required this.progressLabelEnd,
    required this.progressValue,
    required this.click
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => click(),
      child: CardContain(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                    icon: Icon(Icons.arrow_forward_ios_rounded),
                  onPressed: () => click(),  // Corrected here

                ),
              ],
            ),
            SizedBox(height: 8),
            Text(subtitle, style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 16),
            Text("$progressLabelStart - $progressLabelEnd"),
            SizedBox(
              //height: 8.0,
              child: CustomProgressBar(
                progress: progressValue * 100, // Convert to percentage
              ),
            ),
          ],
        ),
      ),
    );
  }
}

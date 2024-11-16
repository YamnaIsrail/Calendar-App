import 'package:flutter/material.dart';

class PhaseInfo extends StatelessWidget {
  final String title;
  final String content;

  PhaseInfo({required this.title, required this.content,});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,  // Ensure column size adjusts
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    //overflow: TextOverflow.ellipsis,  // Prevent text overflow
                  ),
                  SizedBox(height: 4),
                  Text(
                    content,
                   // overflow: TextOverflow.ellipsis,  // Prevent text overflow
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
//
// class CyclePhaseCard extends StatelessWidget {
//   final IconData icon;
//   final Color color;
//   final String phase;
//   final String date;
//
//   const CyclePhaseCard({
//     Key? key,
//     required this.icon,
//     required this.color,
//     required this.phase,
//     required this.date,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: color,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0), // Add some padding for better layout
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center, // Align text to the start
//           children: [
//             Text(
//               phase,
//               style: const TextStyle(fontWeight: FontWeight.bold), // Style for emphasis
//             ),
//             Text(date),
//             Icon(icon),
//           ],
//         ),
//       ),
//     );
//   }
// }
class CyclePhaseCard extends StatelessWidget {
  final Icon? myicon;
  final ImageProvider? image;
  final Color color;
  final String phase;
  final String date;

  const CyclePhaseCard({
    Key? key,
    this.myicon,
    this.image,
    required this.color,
    required this.phase,
    required this.date,
  })  : assert(myicon != null || image != null, 'Either icon or image must be provided'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: SizedBox(
        width: 140, // Set minimum width
        height: 110,
        child: Padding(
          padding: const EdgeInsets.only(right: 5.0, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(date,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                phase,
                style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
              ),

              if (image != null)
                Image(image: image!, width: 49, height: 49) // Display image if provided
              else if (myicon != null)
                myicon!, // Display icon if provided
            ],
          ),
        ),
      ),
    );
  }
}
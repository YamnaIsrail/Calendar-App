import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
//
// class FeedbackScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return bgContainer(
//         child: Scaffold(
//       backgroundColor: Colors.transparent,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(8.0),
//         scrollDirection: Axis.vertical,
//         children: [
//             Image.asset(
//               "assets/chat.png",
//               height: 100,
//               width: 100,
//           ),
//             SizedBox(height: 10,),
//             Container(
//               padding: const EdgeInsets.all(8.0),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 color: Colors.white,
//               ),
//               child: Column(
//                 children: [
//                   Text(
//                     'What are you not satisfied with?',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 16),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           FeedbackOption(label: 'Prediction'),
//                           SizedBox(width: 20), // Add space between buttons
//                           FeedbackOption(label: 'Design'),
//                         ],
//                       ),
//                       SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           FeedbackOption(label: 'Reminders'),
//                           SizedBox(width: 20),
//                           FeedbackOption(label: 'Ads'),
//                         ],
//                       ),
//                       SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           FeedbackOption(label: 'Translation'),
//                           SizedBox(width: 20),
//                           FeedbackOption(label: 'Others'),
//                         ],
//                       ),
//                       SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           FeedbackOption(label: 'Backup & Restore'),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 24),
//             Container(
//               padding: const EdgeInsets.all(8.0),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 color: Colors.white,
//               ),
//               child: Column(
//                 children: [
//                   Text(
//                     'Kindly send us a detailed explanation of your issue via email to ensure a quicker resolution.',
//                     style: TextStyle(fontSize: 16, color: Colors.grey),
//                     textAlign: TextAlign.center,
//                   ),
//                   Icon(
//                     Icons.add_photo_alternate_outlined,
//                     color: Colors.grey,
//                     size: 76,
//                   ),
//                 ],
//               ),
//             ),
//             Spacer(),
//             CustomButton(
//               text: 'Submit',
//               backgroundColor: primaryColor,
//               onPressed: () {},
//             )
//           ],
//         ),
//
//     ));
//   }
// }
//
// class FeedbackOption extends StatelessWidget {
//   final String label;
//   const FeedbackOption({required this.label});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 107,
//       height: 35,
//       alignment: Alignment.center,
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//       decoration: BoxDecoration(
//           color: Color(0xffFFC4E8), borderRadius: BorderRadius.circular(16)),
//       child: Text(
//         '$label',
//         style: TextStyle(
//           color: Colors.black,
//         ),
//       ),
//     );
//   }
// }

import 'package:url_launcher/url_launcher.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final List<String> _feedbackOptions = [
    'Prediction',
    'Design',
    'Reminders',
    'Ads',
    'Translation',
    'Others',
    'Backup & Restore',
  ];
  final Set<String> _selectedOptions = {}; // To store selected options

  // Function to launch email client
  void _openEmailClient() async {
    final String email = "yamnaisrailkhan@gmail.com";
    final Uri emailUri = Uri.parse("mailto:$email");

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open email client.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: ListView(
          padding: const EdgeInsets.all(8.0),
          scrollDirection: Axis.vertical,
          children: [
            Image.asset(
              "assets/chat.png",
              height: 100,
              width: 100,
            ),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Text(
                    'What are you not satisfied with?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: _feedbackOptions.map((option) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_selectedOptions.contains(option)) {
                              _selectedOptions.remove(option);
                            } else {
                              _selectedOptions.add(option);
                            }
                          });
                        },
                        child: FeedbackOption(
                          label: option,
                          isSelected: _selectedOptions.contains(option),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Text(
                    'Kindly send us a detailed explanation of your issue via email to ensure a quicker resolution.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    color: Colors.grey,
                    size: 76,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            CustomButton(
              text: 'Submit',
              backgroundColor: primaryColor,
              onPressed: _openEmailClient,
            ),
          ],
        ),
      ),
    );
  }
}

class FeedbackOption extends StatelessWidget {
  final String label;
  final bool isSelected;

  const FeedbackOption({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 107,
      height: 35,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: isSelected ? Color(0xffFFC4E8) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Colors.black : Colors.grey,
          width: 1.0,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.grey.shade600,
        ),
      ),
    );
  }
}

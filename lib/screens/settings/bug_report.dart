import 'dart:io';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

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
    'Backup',
  ];
  final Set<String> _selectedOptions = {}; // To store selected options
  File? _imageFile; // To store selected image file
  String? _errorMessage; // To store error message if there's an issue with email

  Future<void> _openEmailClient() async {
    String subject = 'Feedback on ${_selectedOptions.isEmpty ? 'App' : _selectedOptions.join(', ')}';
    String body = 'I found an issue in the following areas: ${_selectedOptions.isEmpty ? 'No specific feedback' : _selectedOptions.join(', ')}.\n\n';

    List<String> attachments = [];

    if (_imageFile != null) {
      // Use file URI for Android 13+ compatibility
      if (Platform.isAndroid && _imageFile!.existsSync()) {
        attachments.add(_imageFile!.path); // Add file URI directly (file://)
      }
    }

    final Email email = Email(
      body: body,
      subject: subject,
      recipients: ['so2os.lab@gmail.com'],
      attachmentPaths: attachments.isNotEmpty ? attachments : [], // Only include if attachment exists
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email sent successfully.")),
      );
    } catch (error) {
      //print("Error sending email: $error");

      setState(() {
        _imageFile = null;
        _errorMessage = "Please attach the image manually \nif there is an issue with the attachment.";

      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sending email.")),
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
          padding: EdgeInsets.all(8.0),
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
            // Container(
            //   padding: const EdgeInsets.all(8.0),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(16),
            //     color: Colors.white,
            //   ),
            //   child: Column(
            //     children: [
            //       Text(
            //         'Kindly send us a detailed explanation of your issue via email to ensure a quicker resolution.',
            //         style: TextStyle(fontSize: 16, color: Colors.grey),
            //         textAlign: TextAlign.center,
            //       ),
            //       _imageFile != null
            //           ? Image.file(
            //         _imageFile!,
            //         height: 76,
            //         width: 76,
            //         fit: BoxFit.cover,
            //       )
            //           : IconButton(
            //         icon: Icon(Icons.add_photo_alternate_outlined),
            //         color: Colors.grey,
            //         iconSize: 76,
            //         onPressed: _pickImage,
            //       ),
            //
            //       if (_errorMessage != null)
            //         Padding(
            //           padding: const EdgeInsets.only(top: 8.0),
            //           child: Text(
            //             _errorMessage!,
            //             style: TextStyle(color: Colors.red, fontSize: 14),
            //             textAlign: TextAlign.center,
            //           ),
            //         ),
            //
            //     ],
            //   ),
            // ),
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

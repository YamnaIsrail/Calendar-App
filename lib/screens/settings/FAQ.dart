import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/screens/settings/bug_report.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      'question': 'Add a past period record',
      'answer': 'Go to Settings > Show or Hide Options > Enable "Show Past Period Records".'
    },
    {
      'question': 'Record start/end of my periods',
      'answer': " On the Home Screen, go to the Cycle Tracker (the center tab in the "
          "navigation bar). This page shows buttons"
          " labeled Start Period and End Period. You can tap these buttons "
          "to record or edit the start and end dates of your period."
    },
    {
      'question': 'Transfer data to Android',
      'answer': 'Go to Settings > Backup & Restore > Export to Android.'
    },
    {
      'question': 'Fertile days disappear on the calendar',
      'answer': 'Go to Settings > Show or Hide Options > Ensure "Fertile Days" is enabled.'
    },
    {
      'question': 'Transfer data to iOS',
      'answer': 'Use Settings > Backup & Restore to export data, then import on iOS.'
    },
    {
      'question': 'Hide fertile days on the calendar',
      'answer': 'Go to Settings > Show or Hide Options > Disable "Fertile Days".'
    },
    {
      'question': 'Delete a period record',
      'answer': 'Navigate to the calendar, select the period record, and choose "Delete".'
    },
    {
      'question': 'Adjust fertile days on the calendar',
      'answer': 'Go to Settings > Cycle Length > Update your cycle details.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "FAQ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            Text(
              "How can we help you?",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            CustomButton(
              text: "I need more help",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FeedbackScreen()),
                );
              },
              backgroundColor: primaryColor,
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: faqs.length,
                  itemBuilder: (context, index) {
                    final faq = faqs[index];
                    return FAQItem(question: faq['question']!, answer: faq['answer']!);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      collapsedIconColor: Colors.grey,
      iconColor: Colors.blue,
      trailing: Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.blue,
        size: 24,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            answer,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}

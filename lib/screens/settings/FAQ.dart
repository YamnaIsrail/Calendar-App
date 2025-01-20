import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/screens/settings/bug_report.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      'question': 'Add a past period record',
      'answer': '1. Navigate to Cycle Page > My Cycles > Add/Edit Periods > Select Dates, OR\n'
          '2. Use the Start/End buttons on the Cycle page.'
    },
    {
      'question': 'Record start/end of my periods',
      'answer': 'On the Home Screen, go to Cycle Page (center tab) and tap Start Period or End Period to record or edit your dates.'
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
      'question': 'Hide fertile days on the calendar',
      'answer': 'Go to Settings > Show or Hide Options > Disable "Fertile Days".'
    },
    {
      'question': 'Delete a period record',
      'answer': ' Navigate to Cycle Page > click on Remove Button > select the period record, to "Delete".'
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

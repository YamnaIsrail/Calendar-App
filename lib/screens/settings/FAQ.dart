
import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('FAQ'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          FAQItem(question: 'Add a past period record'),
          FAQItem(question: 'Record start/end of my periods'),
          FAQItem(question: 'Transfer data to Android'),
          FAQItem(question: 'Fertile days disappear on the calendar'),
          FAQItem(question: 'Transfer data to iOS'),
          FAQItem(question: 'Hide fertile days on the calendar'),
          FAQItem(question: 'Delete a period record'),
          FAQItem(question: 'Adjust fertile days on the calendar'),
        ],
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  const FAQItem({required this.question});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(question),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Answer goes here...'),
        ),
      ],
    );
  }
}

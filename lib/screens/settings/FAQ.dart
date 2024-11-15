import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        scrollDirection: Axis.vertical,
        children: [
          Text(
            "How can we help you?",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          CustomButton(
              text: "I need more help",
              onPressed: () {},
              backgroundColor: primaryColor),
          SizedBox(
            height: 20,
          ),
          Container(
            color: Colors.white,
            child: Column(
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
          ),
        ],
      ),
    ));
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  const FAQItem({required this.question});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      collapsedIconColor: Colors.grey, // Icon color when collapsed
      iconColor: Colors.blue, // Icon color when expanded
      trailing: Icon(
        Icons.arrow_drop_down_sharp,
        color: primaryColor,
        size: 24,
      ), // Custom icon styling
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Answer goes here...',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}

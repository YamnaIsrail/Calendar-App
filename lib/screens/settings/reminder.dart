import 'package:calender_app/screens/settings/item.dart';
import 'package:flutter/material.dart';

class ReminderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('Reminders'),
      ),
      body: ListView(
        children: [
          CustomItem(title: 'Period reminder'),
          CustomItem(title: 'Period input reminder'),
          CustomItem(title: 'Fertility reminder'),
          CustomItem(title: 'Ovulation reminder'),
          Divider(),
          SectionHeader(title: 'Medicine'),
          CustomItem(title: 'Add Medicine'),
          SectionHeader(title: 'Life Style'),
          CustomItem(title: 'Drink Water'),
        ],
      ),
    );
  }
}

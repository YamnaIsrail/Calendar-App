import 'package:calender_app/screens/settings/item.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';

class ReminderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  bgContainer(
        child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
        title: Text(
        "Reminder",
        style: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 27),
    ),
    centerTitle: true,
    backgroundColor: Colors.transparent,
    ),
    body:  Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
          children: [
            SectionHeader(title: 'Period & Ovulation'),

            Container(
              color: Colors.white,
              child: Column(
                children: [
                  CustomItem(title: 'Period reminder'),
                  CustomItem(title: 'Period input reminder'),
                  CustomItem(title: 'Fertility reminder'),
                  CustomItem(title: 'Ovulation reminder'),
                ],
              ),
            ),
            SectionHeader(title: 'Medicine'),
            Container(
                color: Colors.white,
                child:
                ListTile(
                  title: Text("Add Medicine"),
                  trailing: Icon(Icons.add, color: Colors.blueAccent,),
                ),),

            SectionHeader(title: 'Life Style'),

            Container(
              color: Colors.white,
              child: CustomItem(title: 'Drink Water'),)
          ],
        ),
    ),
    )
    );
  }
}

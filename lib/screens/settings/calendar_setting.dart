import 'package:calender_app/screens/settings/item.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';

class CalendarSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  bgContainer(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              "Calendar",
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
                Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Aligns items to the start
                    children: [
                      SectionHeader(title: 'DateFormat', caption: "System default",),
                     ],
                  ),
                ),
                SizedBox(height: 20,),


                Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Aligns items to the start
                    children: [
                      SectionHeader(title: 'First Day of weeek', caption: "Sunday",),
                    ],
                  ),
                ),
                SizedBox(height: 20,),


                Text(
                  "Show/hide Option",
                  style: TextStyle(fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
                CustomItem(title: 'Intercourse Option'),
                CustomItem(title: 'Condom Option'),
                CustomItem(title: 'Chance of getting pregnant'),
                CustomItem(title: 'Ovulation / Fertile'),

                CustomItem(title: 'Future Period'),
                CustomItem(title: 'Contraceptive Medicine'),

              ],
            ),
          ),
        )
    );
  }
}

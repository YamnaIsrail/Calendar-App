import 'package:calender_app/screens/settings/item.dart';
import 'package:calender_app/screens/settings/show_hide_option/show_hide_symptoms.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';

import 'show_hide_mood.dart';

class ShowHideOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  bgContainer(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              "Show/Hide option",
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
            margin: EdgeInsets.symmetric(vertical: 5),
            color: Colors.white,
            child: ListTile(
              title: Text("Symptoms",
                style: TextStyle(
                    fontSize: 16
                ),
              ),
              trailing: IconButton(onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShowHideSymptomScreen()
            ),
            );
            },
                  icon: Icon(Icons.arrow_forward_ios)
              )
            ),
          ),

                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  color: Colors.white,
                  child: ListTile(
                      title: Text("Moods",
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                      trailing: IconButton(onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ShowHideMood()
                          ),
                        );
                      },
                          icon: Icon(Icons.arrow_forward_ios)
                      )
                  ),
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
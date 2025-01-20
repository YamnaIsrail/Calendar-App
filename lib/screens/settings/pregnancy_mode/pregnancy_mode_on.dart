import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/screens/settings/settings_page.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'preganancy_page.dart';

class congrats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return bgContainer(child:
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            " ",
          ),
          leading: IconButton(onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
                  (route) => false,
            );
          }, icon: Icon(Icons.clear_rounded), color: Colors.grey, iconSize: 30,),
        ),

        body:  Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

             SvgPicture.asset("assets/pregnancy/Congratulations.svg"),
              Text(
                "Mom to be!",
                style: TextStyle(
                    fontSize: 24,
                   color: primaryColor,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              //Icon(Icons.cake, size: 100, color: Colors.pink),
              SvgPicture.asset("assets/pregnancy/baby.svg"),
              SizedBox(height: 20),
              Container(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),

                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Here you can:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),

                    ListTile(
                      title: Text("Count down the days until the birth of your baby."),
                      leading:  Icon(Icons.hourglass_bottom, color: Colors.blue, size: 40.0),

                    ),
                    SizedBox(height: 16),
                    ListTile(
                      title:   Text("Track your weight & health data and share with your doctor."),
                        leading: Icon(Icons.favorite, color: Colors.red, size: 40.0),

                    ),

                    CustomButton(text: "Continue",
                        onPressed: (){
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (
                                      context)=> PregnancyScreen()));
                        },
                        backgroundColor: primaryColor),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  SvgPicture.asset("assets/pregnancy/tiles.svg"),
                  SvgPicture.asset("assets/pregnancy/blocks.svg"),

                ],
              )
            ],
          ),
        ),
      ),
      )
    );
  }
}

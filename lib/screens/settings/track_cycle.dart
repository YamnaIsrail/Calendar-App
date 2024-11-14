import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';
class TrackCycleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,

        appBar: AppBar(
          title: Text("Add Note"),
          backgroundColor: Colors.transparent,
        ),
        body: Column(
         // mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              color: Colors.white,
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.symmetric(vertical: 8.0),

              child: ListTile(
                title: Text("Add a new user"),
                leading: CircleAvatar(
                    backgroundColor: secondaryColor,
                    child: Icon(Icons.add)),
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.symmetric(vertical: 8.0),

              child: ListTile(
                title: Text("Default User"),
                leading: CircleAvatar(
                    backgroundColor: secondaryColor,
                    child: Icon(Icons.person)),
                trailing: CircleAvatar(
                    backgroundColor: primaryColor,
                    child: Icon(Icons.check, color: Colors.white,)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

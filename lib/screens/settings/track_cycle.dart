import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/screens/flow2/home_flow2.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/screens/homeScreen.dart';
import 'package:calender_app/screens/question/q1.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class TrackCycleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CycleProvider>(
      builder: (context, cycleProvider, child) {
        return bgContainer(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text("Add User"),
              backgroundColor: Colors.transparent,
            ),
            body: Column(
              children: [
                // New User section
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text("Add a new user"),
                    leading: CircleAvatar(
                        backgroundColor: secondaryColor,
                        child: Icon(Icons.add)),
                    onTap: () {
                      // Functionality to add new user (e.g., prompt to enter a name)
                      _addNewUserDialog(context, cycleProvider);
                    },
                  ),
                ),
                // Current Default User section
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text("Current User: ${cycleProvider.userName}"),
                    leading: CircleAvatar(
                        backgroundColor: secondaryColor,
                        child: Icon(Icons.person)),
                    trailing: CircleAvatar(
                        backgroundColor: primaryColor,
                        child: Icon(Icons.check, color: Colors.white)),
                    onTap: () {
                      // Optionally add functionality to change the name here
                      _addNewUserDialog(context, cycleProvider);
                    },
                  ),
                ),
                // Cycle Information
                Container(
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text("Cycle Info: ${cycleProvider.cycleLength} days cycle, ${cycleProvider.periodLength} days period"),
                    leading: CircleAvatar(
                        backgroundColor: secondaryColor,
                        child: IconButton(
                            icon: Icon(Icons.calendar_today),
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => QuestionScreen1()),
                            );

                          },

                        )),
                    subtitle: Text("Next period in: ${cycleProvider.getDaysUntilNextPeriod()} days"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Method to show a dialog for adding or updating the user name
  void _addNewUserDialog(BuildContext context, CycleProvider cycleProvider) {
    TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter User Name"),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: "Enter your name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String name = nameController.text.trim();
                if (name.isNotEmpty) {
                  cycleProvider.updateUserName(name);
                  Navigator.pop(context);
                }
              },
              child: Text("Save"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}

//
// class TrackCycleScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return bgContainer(
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//
//         appBar: AppBar(
//           title: Text("Add Note"),
//           backgroundColor: Colors.transparent,
//         ),
//         body: Column(
//          // mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//
//             Container(
//               color: Colors.white,
//               padding: EdgeInsets.all(8.0),
//               margin: EdgeInsets.symmetric(vertical: 8.0),
//
//               child: ListTile(
//                 title: Text("Add a new user"),
//                 leading: CircleAvatar(
//                     backgroundColor: secondaryColor,
//                     child: Icon(Icons.add)),
//               ),
//             ),
//             Container(
//               color: Colors.white,
//               padding: EdgeInsets.all(8.0),
//               margin: EdgeInsets.symmetric(vertical: 8.0),
//
//               child: ListTile(
//                 title: Text("Default User"),
//                 leading: CircleAvatar(
//                     backgroundColor: secondaryColor,
//                     child: Icon(Icons.person)),
//                 trailing: CircleAvatar(
//                     backgroundColor: primaryColor,
//                     child: Icon(Icons.check, color: Colors.white,)),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';

class PeriodLength extends StatelessWidget {
  const PeriodLength({super.key});

  @override
  Widget build(BuildContext context) {
    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar:  AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Periods",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Color(0xFFFFC4E8),

                    borderRadius: BorderRadius.circular(50)
                ),
                child: Icon(Icons.arrow_back)),
            onPressed: () => Navigator.pop(context),
          ),

          actions: [
            IconButton(
              icon: Icon(Icons.check_box, color: Color(0xFFEB1D98),),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              margin:  const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),

                color: Colors.white,
              child: ListTile(
                title: Text("Period Length"),
                trailing: Text("6 days"),
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),

              child: Text("Bleeding usually lasts between 4-7 days."),
            ),
            Container(
                margin:  const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),

                color: Colors.white,
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Use Average ",
                        style: TextStyle(fontWeight: FontWeight.bold
                        ),),
                      Text("Smart Calculate"),

                    ],
                  ),
                  trailing: Switch(
                      value: false,
                      onChanged: (bool newValue) {},


                  ),
                )
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Turn on the option,"
                  " according to your previous records,"
                  " use average value to predict your next period."),
            ),


          ],
        ),
      ),
    );
  }
}

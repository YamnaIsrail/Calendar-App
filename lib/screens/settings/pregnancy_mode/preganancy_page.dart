import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';

class PregnancyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Pregnancy"),
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
        body: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PregnancyOptionTile(
                title: "Estimated start of gestation",
                subtitle: "Oct 3, 2024",
                onTap: () {
                  // Placeholder for future functionality (e.g., show date picker)
                },
              ),
              PregnancyOptionTile(
                title: "Display on the homepage",
                subtitle: "3W 0D since pregnancy",
                onTap: () {
                  // Placeholder for toggle functionality
                },
              ),
              PregnancyOptionTile(
                title: "My baby was born!",
                subtitle: "",
                textcolor: Color(0xFFEB1D98),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CongratulationsScreen()),
                  );
                },
              ),
              PregnancyOptionTile(
                title: "Turn off pregnancy mode",
                subtitle: "",
                onTap: () {
                  Navigator.pop(context); // Navigate back as a placeholder
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PregnancyOptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? textcolor;

  const PregnancyOptionTile({
    this.textcolor,
    required this.title,
    required this.subtitle,
    required this.onTap,

     Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin:  const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 20 ),
        color: Colors.white,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
              style: TextStyle(color: textcolor?? Color(0xff2d2d2d), fontWeight: textcolor!=null ? FontWeight.bold : FontWeight.normal),
            ),
            if (subtitle.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  subtitle,
                  style: TextStyle(color: Color(0xff2F1C90)),
                ),
              ),
             ],
        ),
      ),
    );
  }
}

class CongratulationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Congratulations"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Congratulations! Mom to be!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Icon(Icons.cake, size: 100, color: Colors.pink),
            SizedBox(height: 20),
            Text(
              "Here you can:\n\n• Count down the days until your baby is born.\n• Track your weight & health data and share it with your doctor.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

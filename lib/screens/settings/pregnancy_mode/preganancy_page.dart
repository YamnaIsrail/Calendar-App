import 'package:calender_app/provider/preg_provider.dart';
import 'package:calender_app/screens/settings/settings_page.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';
import 'congratualtions_screen.dart';
import 'package:provider/provider.dart';

class PregnancyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pregnancyModeProvider = context.watch<PregnancyModeProvider>();

    return bgContainer(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SettingsPage()),
          );
          return false; // Prevent default back navigation
        },
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
                    borderRadius: BorderRadius.circular(50)),
                child: Icon(Icons.arrow_back),
              ),
              onPressed: () =>   Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.check_box, color: Color(0xFFEB1D98)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Section 1: Estimated start of gestation
                PregnancyOptionTile(
                  title: "Estimated start of gestation",
                  subtitle: pregnancyModeProvider.gestationStart != null
                      ? "${pregnancyModeProvider.gestationStart?.toLocal().toString().split(' ')[0]}"
                      : "Unknown",
                  onTap: () {
                    _showDatePicker(context, pregnancyModeProvider);
                  },
                ),
                SizedBox(height: 8),
                // Section 2: Display on the homepage with gestation progress
                PregnancyOptionTile(
                  title: "Display on the homepage",
                  subtitle: pregnancyModeProvider.gestationWeeks != null && pregnancyModeProvider.gestationDays != null
                      ? "${pregnancyModeProvider.gestationWeeks}W ${pregnancyModeProvider.gestationDays}D since pregnancy"
                      : "Unknown",
                  onTap: () {
                    // print("Toggled display on homepage feature.");
                  },
                ),
                SizedBox(height: 8),
                // Section 3: Placeholder for congratulation screen
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
                SizedBox(height: 8),
                // Section 4: Turn off pregnancy mode
                PregnancyOptionTile(
                  title: "Turn off pregnancy mode",
                  subtitle: "",
                  onTap: () {
                    pregnancyModeProvider.togglePregnancyMode(false);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDatePicker(
      BuildContext context,
      PregnancyModeProvider pregnancyModeProvider)
  async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: pregnancyModeProvider.gestationStart ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (newDate != null) {
      if (newDate.isAfter(DateTime.now())) {
        // Show a message to the user about selecting a valid date
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a valid date (not in the future).')),
        );
        return; // Do not proceed further if the date is in the future
      } else {
        pregnancyModeProvider.gestationStart = newDate;
        pregnancyModeProvider.calculateGestationWeeksAndDays();
        pregnancyModeProvider.notifyListeners();
      }
      // Update the gestation start date in the provider

    }
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
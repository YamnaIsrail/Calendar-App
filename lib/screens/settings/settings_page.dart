import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/screens/settings/cycle_length.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

import 'ovulation.dart';
import 'partner_info.dart';
import 'period_length.dart';
import 'pregnancy_mode/pregnancy_mode_on.dart';
import 'track_cycle.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
        gradient: LinearGradient(
          colors: [
            Color(0xFFE8EAF6),
            Color(0xFFF3E5F5)
          ], // Light gradient background
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Settings",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(onPressed: () {}, icon: Icon(Icons.close)),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserProfileSection(),
                GoalSection(),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SettingsOption(
                    icon: Icons.notifications,
                    title: "Reminders",
                    trailing: Text("6 Days"),
                  ),
                ),
                SettingsOptionSection(),
                LanguageOptionSection(),
                FAQOptionSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Define individual sections
class UserProfileSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        CircleAvatar(
          backgroundImage: AssetImage('assets/profile.jpg'),
          child: Icon(
            Icons.person,
          ),
          radius: 35,
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Sign in and Synchronize your data",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xff142d7f),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "Sync Data",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

class GoalSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Text(
              "My Goal",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomButton(
                  text: "Track my period",
                  onPressed: () {},
                  backgroundColor: primaryColor,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: CustomButton(
                  text: "Track my pregnancy",
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => congrats()));
                  },
                  backgroundColor: secondaryColor,
                  textColor: Colors.black,
                ),
              ),
            ],
          ),
          Column(
            children: [
              SettingsOption(
                  icon: Icons.water_drop,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PeriodLength()),
                    );
                  },
                  title: "Period Length",
                  trailing: Text("6 Days")),
              SettingsOption(
                  icon: Icons.calendar_today,
                  title: "Cycle Length",
                  trailing: Text("25 Days"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CycleLength()),
                  );
                },

              ), SettingsOption(
                icon: Icons.calendar_today,
                title: "Ovulation and fertile",
                 onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Ovulation()),
                  );
                },

              ),

              SettingsOption(
                icon: Icons.lock,
                title: "Password",
                trailing: Switch(
                  value: false,
                  onChanged: (bool newValue) {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SettingsOptionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      margin: EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          SettingsOption(icon: Icons.backup, title: "Backup & Restore"),
          SettingsOption(icon: Icons.lock, title: "Password"),
          SettingsOption(icon: Icons.person,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PartnerModeScreen()),
                );
              },
              title: "Partner Mode"),
          SettingsOption(
              icon: Icons.document_scanner, title: "Export document to Doctor"),
          SettingsOption(icon: Icons.person_add,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrackCycleScreen()),
                );
              },

              title: "Track other’s Cycles"),
        ],
      ),
    );
  }
}

class LanguageOptionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      margin: EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          SettingsOption(icon: Icons.language, title: "Language Options"),
          SettingsOption(icon: Icons.visibility, title: "Show or Hide Options"),
          SettingsOption(icon: Icons.calendar_today, title: "Calendar"),
        ],
      ),
    );
  }
}

class FAQOptionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      margin: EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          SettingsOption(icon: Icons.question_answer, title: "FAQ"),
          SettingsOption(
              icon: Icons.bug_report, title: "Bug report & Feedback"),
          SettingsOption(
              icon: Icons.featured_play_list, title: "Request a new feature"),
          SettingsOption(icon: Icons.star, title: "Rate us on Google Play"),
          SettingsOption(icon: Icons.share, title: "Share with friends"),
          SettingsOption(icon: Icons.privacy_tip, title: "Privacy"),
        ],
      ),
    );
  }
}

class SettingsOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap; // Optional onTap function

  SettingsOption({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap, // Include onTap as a parameter
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.pink),
      title: Text(title),
      trailing: trailing,
      onTap: onTap ??
          () {
            // Default action if no onTap function is provided
            print('Tapped on $title');
          },
    );
  }
}

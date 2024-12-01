import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/screens/globals.dart';
// import 'package:calender_app/screens/settings/calendar_setting/calendar_setting.dart';
import 'package:calender_app/screens/settings/cycle_length.dart';
import 'package:calender_app/screens/settings/language_option.dart';
import 'package:calender_app/screens/settings/pregnancy_mode/congratualtions_screen.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'FAQ.dart';
import 'auth/password/create_password.dart';
import 'backup_restore/backup_and_restore_screen.dart';
import 'bug_report.dart';
import 'calendar_setting/calendar_setting.dart';
// import 'dialog.dart';
import 'dialog.dart';
import 'ovulation.dart';
import 'partner_mode/partner_info.dart';
import 'period_length.dart';
import 'pregnancy_mode/pregnancy_mode_on.dart';
import 'reminder.dart';
import 'show_hide_option/show_hide_option.dart';
import 'track_cycle.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Settings",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: Icon(Icons.close)),
        ),
        body: SingleChildScrollView(

          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserProfileSection1(),
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReminderScreen()),
                      );
                    },

                    trailing: Icon(Icons.notifications),
                  ),
                ),
                SettingsOptionSection(),
                LanguageOptionSection(),
                FAQOptionSection(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          // Call showFirstDayOfWeekDialog
                          DialogHelper.showConfirmPopup(context, (){});  },

                        child: Text("Delete All Data",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: primaryColor)
                          ,)
                    ),
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserProfileSection1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align items at the top
        children: [
          CircleAvatar(
            child: Icon(
              Icons.person,
            ),
            radius: 35,
          ),
          SizedBox(width: 16),
          Expanded( // Ensures text and button fit within the available space
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
              children: [
                Text(
                  "Sign in and Synchronize your data",
                  softWrap: true, // Enables text wrapping
                  overflow: TextOverflow.clip, // Prevents text overflow
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft, // Align button to the left
                  child: Container(
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GoalSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<CycleProvider>(context);
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PeriodLength()),
                    );
                  },
                  backgroundColor: primaryColor,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: CustomButton(
                  text: "Track my pregnancy",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => congrats()),
                    );
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
                title: "Period Length",
                trailing: Text("${cycleProvider.periodLength} Days"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PeriodLength()),
                  );
                },
              ),
              SettingsOption(
                icon: Icons.calendar_today,
                title: "Cycle Length",
                trailing: Text("${cycleProvider.cycleLength} Days"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CycleLength()),
                  );
                },
              ),
              SettingsOption(
                icon: Icons.calendar_today,
                title: "Ovulation and fertile",
                trailing: Text("Details"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Ovulation()),
                  );
                },
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
          SettingsOption(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BackupAndRestoreScreen()),
                );
              },
              icon: Icons.backup,
              title: "Backup & Restore"),
          SettingsOption(
              icon: Icons.lock,
              title: "Password",
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreatePasswordScreen()),
                );
              }

          ),
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
          SettingsOption(icon: Icons.language, title: "Language Options",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (
                      context) => LanguageOptionScreen()),
                );
              }),
          SettingsOption(icon: Icons.visibility,
              title: "Show or Hide Options",
              onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShowHideOption()),
            );
          }),
          SettingsOption(icon: Icons.calendar_today, title: "Calendar",
            onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CalendarSetting()),
            );
          }

          ),
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
          SettingsOption(icon: Icons.question_answer,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FAQScreen()),
                );
              },

              title: "FAQ"),
          SettingsOption(
              icon: Icons.bug_report,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FeedbackScreen()),
                );
              },

              title: "Bug report & Feedback"),
          SettingsOption(
              icon: Icons.featured_play_list, title: "Request a new feature"),
          SettingsOption(icon: Icons.star, title: "Rate us on Google Play",
            onTap: () {
              // Call showFirstDayOfWeekDialog
              DialogHelper.showRatingPopup(context, (rating) {
                print('Selected Rating: $rating');
              });
            },
          ),
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
      leading: Icon(icon, color: primaryColor),
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

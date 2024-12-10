import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/provider/preg_provider.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/screens/settings/cycle_length.dart';
import 'package:calender_app/screens/settings/language_option.dart';
import 'package:calender_app/screens/settings/pregnancy_mode/congratualtions_screen.dart';
import 'package:calender_app/screens/settings/privacy_policy.dart';
import 'package:calender_app/screens/settings/translation.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'FAQ.dart';
import 'auth/password/password.dart';
import 'backup_restore/backup_and_restore_screen.dart';
import 'bug_report.dart';
import 'calendar_setting/calendar_setting.dart';
import 'dialog.dart';
import 'export_document/share_document.dart';
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
                ), //Reminders Section
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
                         )
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
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Color(0xff142d7f),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextButton(
                     child: Text(
                       "Sync Data",
                       style: TextStyle(
                         fontSize: 16,
                         fontWeight: FontWeight.w500,
                         color: Colors.white,
                       ),
                     ),
                      onPressed: (){
                        Provider.of<CycleProvider>(context, listen: false).saveCycleDataToFirestore();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => BackupAndRestoreScreen()),
                        // );
                      },
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
    final pregnancyModeProvider = context.watch<PregnancyModeProvider>();

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
                    pregnancyModeProvider.togglePregnancyMode(false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PeriodLength()),
                    );
                  },
                  textColor:  pregnancyModeProvider.isPregnancyMode ? Colors.black : Colors.white!,

                  backgroundColor: pregnancyModeProvider.isPregnancyMode ? secondaryColor! : primaryColor,

                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: CustomButton(
                  text: "Track my pregnancy",
                  onPressed: () {
                    pregnancyModeProvider.togglePregnancyMode(true);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => congrats()),
                    );
                  },
                  backgroundColor: pregnancyModeProvider.isPregnancyMode ? primaryColor : secondaryColor!,

                  textColor:  pregnancyModeProvider.isPregnancyMode ? Colors.white : Colors.black!,

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
                  MaterialPageRoute(builder: (context) => PasswordScreen()),
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
              icon: Icons.document_scanner,
              title: "Export document to Doctor",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExportCyclePage())
                );
              }),
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
          SettingsOption(
            icon: Icons.language,
            title: "Language Options",
            onTap: () {
              // Navigate and pass the 'onLanguageChanged' parameter
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LanguageSelectionScreen(
                    onLanguageChanged: (String language) {
                      // Here, you can define what happens when language is changed.
                      // For example, updating the selected language or saving to shared preferences
                      print("Selected Language: $language");
                    },
                  ),
                ),
              );
            },
          ),
          SettingsOption(
            icon: Icons.visibility,
            title: "Show or Hide Options",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShowHideOption()),
              );
            },
          ),
          SettingsOption(
            icon: Icons.calendar_today,
            title: "Calendar",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarSetting()),
              );
            },
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
          SettingsOption(
            icon: Icons.question_answer,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FAQScreen()),
              );
            },
            title: "FAQ",
          ),
          SettingsOption(
            icon: Icons.bug_report,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedbackScreen()),
              );
            },
            title: "Bug report & Feedback",
          ),
          SettingsOption(
            icon: Icons.featured_play_list,
            title: "Request a new feature",
            onTap: () {
              launchEmail();
            },
          ),
          SettingsOption(
            icon: Icons.star,
            title: "Rate us on Google Play",
            onTap: () {
              DialogHelper.showRatingPopup(context, (rating) {
                print('Selected Rating: $rating');
              });
            },
          ),
          // Share with Friends Section
          SettingsOption(
            icon: Icons.share,
            onTap: () {
              _shareApp();
            },
            title: "Share with friends",
          ),

          SettingsOption(
            icon: Icons.privacy_tip,
            title: "Privacy",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Functionality to share the app link
void _shareApp() {
  const appLink = 'https://play.google.com/store/apps/details?id=com.popularapp.periodcalendar';
  Share.share('Check out this awesome app for tracking your period, symptoms, and ovulation! $appLink');
}

// Method to launch email
Future<void> launchEmail() async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'yamnaisrailkhan@gmail.com',
    queryParameters: {
      'subject': 'Request a New Feature',
      'body': 'I request a new feature.\n\nPlease describe your request here.',
    },
  );

  if (await canLaunchUrl(emailLaunchUri)) {
    await launchUrl(emailLaunchUri);
  } else {
    throw 'Could not launch $emailLaunchUri';
  }
}

class SettingsOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

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

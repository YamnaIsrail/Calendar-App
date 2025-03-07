import 'package:calender_app/auth/auth_services.dart';
import 'package:calender_app/firebase/user_session.dart';
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/provider/preg_provider.dart';
import 'package:calender_app/provider/showhide.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/screens/settings/cycle_length.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:calender_app/screens/settings/privacy_policy.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../../firebase/analytics/analytics_service.dart';
import '../flow2/home_flow2.dart';
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

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  DateTime _startTime= DateTime.now();

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    AnalyticsService.logScreenView("settings_page");
  }

  @override
  void dispose() {
    int duration = DateTime.now().difference(_startTime).inSeconds; // Calculate time spent
    AnalyticsService.logScreenTime("settings_page", duration).then((_) {
      super.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final showHideProvider = context.watch<ShowHideProvider>();

    return bgContainer(
      child: WillPopScope(
        onWillPop: () async {
          int duration = DateTime.now().difference(_startTime).inSeconds;

          AnalyticsService.logScreenTime("SettingsPage",duration );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Flow2Page()),
            (route) => false,
          );
          return false; // Prevent default back navigation
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              "Settings",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Flow2Page()),
                    (route) => false,
                  );
                },
                icon: Icon(Icons.close)),
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
                        AnalyticsService.logEvent("navigate_to_reminders", parameters: {
                          "from_screen": "SettingsPage",
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReminderScreen()),
                        );
                      },
                      trailing: Icon(Icons.notifications),
                    ),
                  ), //Reminders Section
                  SettingsOptionSection(),
                  FAQOptionSection(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            AnalyticsService.logEvent("delete_all_data_confirmed", parameters: {
                              "action": "Delete All Data",
                            });
                            DialogHelper.showConfirmPopup(context, () {
                              DialogHelper
                                  .deleteAllHiveData(); // Call to delete all Hive data from DialogHelper
                            });
                          },
                          child: Text("Delete All Data",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: primaryColor))),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class UserProfileSection1 extends StatefulWidget {
  @override
  _UserProfileSection1State createState() => _UserProfileSection1State();
}

class _UserProfileSection1State extends State<UserProfileSection1> {
  bool? isSignedIn; // Nullable bool to handle loading state
  bool _isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Fetch login status when widget is initialized
  }

  String? userImageUrl;
  String? userName;

  Future<void> _checkLoginStatus() async {
    final status = await SessionManager.checkUserLoginStatus();
    if (status) {
      userImageUrl = await SessionManager.getUserProfileImage();
      userName = await SessionManager.getUserName();
    }
    setState(() {
      isSignedIn = status; // Update state with login status
    });

  }

  @override
  Widget build(BuildContext context) {
    AnalyticsService.logScreenView("SettingsPage");

    if (isSignedIn == null) {
      // Show loading indicator while fetching login status
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: isSignedIn! && userImageUrl != null
                    ? NetworkImage(userImageUrl!)
                    : null,
                child: isSignedIn! && userImageUrl != null
                    ? null
                    : Icon(Icons.person, size: 35),
              ),
              if (isSignedIn! && userName != null)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    userName!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),

            ],
          ),

          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSignedIn!
                      ? "Synchronize your data"
                      : "Sign in and Synchronize your data",
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Color(0xff142d7f),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextButton(
                      child: Text(
                        isSignedIn! ? "Sync Data" : "Sign In",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        if (isSignedIn!) {
                          AnalyticsService.logEvent("sync_data_initiated", parameters: {
                            "action": "Syncing Data",
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Syncing Data..."),
                              backgroundColor: Colors.blue,
                            ),
                          );
                          // Ensure cycle data is saved correctly
                          Provider.of<CycleProvider>(context, listen: false)
                              .saveCycleDataToFirestore();
                        } else {
                          AnalyticsService.logEvent("sign_in_initiated", parameters: {
                            "action": "User  initiated sign-in",
                          });
                          // Call the sign-in method and handle the loading state
                          setState(() {
                            _isLoading = true; // Set loading to true during sign-in
                          });

                          await AuthService().signInWithGoogle(context, (bool isLoading) {
                            setState(() {
                              _isLoading = isLoading; // Update loading state
                            });
                          });
                          // After sign-in, re-check the login status
                          await _checkLoginStatus();
                        }
                      },
                    ),
                  ),
                ),
                if (_isLoading)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: CircularProgressIndicator(),
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
    final showHideProvider = context.watch<ShowHideProvider>();

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
                    AnalyticsService.logEvent("track_period_initiated", parameters: {
                      "action": "Tracking period",
                    });
                    pregnancyModeProvider.togglePregnancyMode(false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PeriodLength()),
                    );
                  },
                  textColor: pregnancyModeProvider.isPregnancyMode
                      ? Colors.black
                      : Colors.white!,
                  backgroundColor: pregnancyModeProvider.isPregnancyMode
                      ? secondaryColor!
                      : primaryColor,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: CustomButton(
                  text: "Track my pregnancy",
                  onPressed: () {
                    AnalyticsService.logEvent("track_pregnancy_initiated", parameters: {
                      "action": "Tracking pregnancy",
                    });
                    pregnancyModeProvider.togglePregnancyMode(true);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => congrats()),
                    );
                  },
                  backgroundColor: pregnancyModeProvider.isPregnancyMode
                      ? primaryColor
                      : secondaryColor!,
                  textColor: pregnancyModeProvider.isPregnancyMode
                      ? Colors.white
                      : Colors.black!,
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
                  AnalyticsService.logEvent("navigate_to_update_period_length", parameters: {
                    "from_screen": "SettingsPage",
                  });
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
                  AnalyticsService.logEvent("navigate_to_update_cycle_length", parameters: {
                    "from_screen": "SettingsPage",
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CycleLength()),
                  );
                },
              ),
              if (showHideProvider.visibilityMap['Ovulation / Fertile'] == true)
                SettingsOption(
                  icon: Icons.calendar_today,
                  title: "Ovulation and fertile",
                  trailing: Text("Details"),
                  onTap: () {
                    AnalyticsService.logEvent("navigate_to_ovulation_fertile_settings", parameters: {
                      "from_screen": "SettingsPage",
                    });
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
              onTap: () {
                AnalyticsService.logEvent("Navigate to Backup and Restore Screen", parameters: {
                  "from_screen": "SettingsPage",
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BackupAndRestoreScreen()),
                );
              },
              icon: Icons.backup,
              title: "Backup & Restore"),
          SettingsOption(
              icon: Icons.lock,
              title: "Password",
              onTap: () {
                AnalyticsService.logEvent("Navigate to set Pin/Password Screen", parameters: {
                  "from_screen": "SettingsPage",
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PasswordScreen()),
                );
              }),
          SettingsOption(
              icon: Icons.person,
              onTap: () {
                AnalyticsService.logEvent("Navigate to Link with Partner Screens", parameters: {
                  "from_screen": "SettingsPage",
                });
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
                AnalyticsService.logEvent("Export document to Doctor", parameters: {
                  "from_screen": "SettingsPage",
                });
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ExportCyclePage()));
              }),

          SettingsOption(
            icon: Icons.calendar_today,
            title: "Calendar",
            onTap: () {
              AnalyticsService.logEvent("Navigate to Calendar/Show/Hide settings", parameters: {
                "from_screen": "SettingsPage",
              });
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
              AnalyticsService.logEvent("faq_accessed", parameters: {
                "action": "Accessed FAQ",
              });
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
              AnalyticsService.logEvent("feedback_accessed", parameters: {
                "action": "Accessed Report & Feedback",
              });
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
              AnalyticsService.logEvent("feature_request_initiated", parameters: {
                "action": "Requested a new feature",
              });
              launchEmail();
            },
          ),
          SettingsOption(
            icon: Icons.star,
            title: "Rate us on Google Play",
            onTap: () {
              AnalyticsService.logEvent("rate_us_initiated", parameters: {
                "action": "Initiated rating on Google Play",
              });
              DialogHelper.showRatingPopup(context, (rating) {
                  });
            },
          ),
          // Share with Friends Section
          SettingsOption(
            icon: Icons.share,
            onTap: () {

              AnalyticsService.logEvent("share_app", parameters: {
                "action": "Share with friends",
              });
              _shareApp();
            },
            title: "Share with friends",
          ),

          SettingsOption(
            icon: Icons.privacy_tip,
            title: "Privacy",
            onTap: () {
              AnalyticsService.logEvent("privacy_accessed", parameters: {
                "action": "Accessed Privacy Policy",
              });
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
            // print('Tapped on $title');
          },
    );
  }
}
// Functionality to share the app link
Future<void> _shareApp() async {
  // Get the package info
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  // Use final instead of const
  final appLink =
      'https://play.google.com/store/apps/details?id=${packageInfo.packageName}&hl=en';

  // Share the app link
  Share.share(
      'Check out this awesome app for tracking your period, symptoms, and ovulation! $appLink');
}

// Method to launch email
Future<void> launchEmail() async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'so2os.lab@gmail.com',
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

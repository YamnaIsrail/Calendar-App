import '../../../firebase/analytics/analytics_service.dart';
import '../detail page/cycle/water_reminders.dart';
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/provider/date_day_format.dart';
import 'package:calender_app/provider/preg_provider.dart';
import '../../pets/pets_row.dart';
import 'package:calender_app/screens/settings/settings_page.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/flow2_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../admob/banner_ad.dart';
import '../../../widgets/contain.dart';
import '../detail page/cycle/cycle_page_components/category_selection.dart';
import '../detail page/cycle/cycle_page_components/cycle_info_card.dart';
import '../detail page/cycle/cycle_page_components/date_navigation.dart';
import '../detail page/cycle/cycle_page_components/flow_section.dart';
import '../detail page/cycle/cycle_page_components/note_section.dart';
import '../detail page/cycle/cycle_page_components/periods_button.dart';
import '../detail page/cycle/cycle_page_components/water_intake_section.dart';
import '../detail page/cycle/intercourse.dart';
import '../detail page/cycle/medicine.dart';
import '../detail page/cycle/moods.dart';
import '../detail page/cycle/my_cycle.dart';
import '../detail page/cycle/ovulation_screen.dart';
import '../detail page/cycle/symptoms.dart';
import 'package:intl/intl.dart';

class CycleTrackerScreen extends StatelessWidget {
  final String? userImageUrl;

  CycleTrackerScreen({this.userImageUrl});

  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<CycleProvider>(context);
    final pregnancyProvider = Provider.of<PregnancyModeProvider>(context);
    AnalyticsService.logScreenView("My Cycle");

    String formatDate(DateTime date) {
      String selectedFormat = context.watch<SettingsModel>().dateFormat;
      if (selectedFormat == "System Default") {
        return DateFormat.yMd().format(date); // Use system locale's default
      } else {
        return DateFormat(selectedFormat).format(date); // Use selected format
      }
    }

    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          pageTitle: "Today",
          // userImageUrl: userImageUrl,
          onCancel: () {},
          onBack: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsPage()));
          },
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DateNavigation(),
                const SizedBox(height: 10),
                if (!pregnancyProvider
                    .isPregnancyMode) // Check if pregnancy mode is off
                  PeriodButtons(),
                const SizedBox(height: 10),
                FlowSection(),
                const SizedBox(height: 10),

                if (!pregnancyProvider
                    .isPregnancyMode) // Check if pregnancy mode is off
                  CycleInfoCard(
                    title: "My Cycles",
                    subtitle:
                        "${cycleProvider.logCycle()} cycles logged", // Dynamic subtitle
                    progressLabelStart:
                        formatDate(cycleProvider.lastPeriodStart),
                    progressLabelEnd:
                        formatDate(cycleProvider.getNextPeriodDate()),

                    progressValue:
                        (cycleProvider.daysElapsed / cycleProvider.cycleLength)
                            .clamp(0.0, 1.0),
                    click: () {
                      AnalyticsService.logEvent("navigate_to_my_cycles", parameters: {
                        "from_screen": "My Cycle",
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyCyclesScreen()),
                      );
                    },
                  ),

                if (!pregnancyProvider
                    .isPregnancyMode) // Check if pregnancy mode is off
                  const SizedBox(height: 10),

                PetRow(),

                const SizedBox(height: 10),

                NoteSection(),

                const SizedBox(height: 10),
                CategorySection(
                  title: "Intercourse",
                  folderName: "intercourse",
                  targetPage: IntercourseScreen(),
                ),
                CategorySection(
                  title: "Symptoms",
                  folderName: "head",
                  targetPage: Symptoms(),
                ),
                CategorySection(
                  title: "Moods",
                  folderName: "emoji",
                  targetPage: Moods(),
                ),
                //ovul
                GestureDetector(
                  onTap: () {
                    AnalyticsService.logEvent("open_ovulation_dialog", parameters: {
                      "from_screen": "My Cycle",
                    });

    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            child:
                                OvulationScreen(), // Your ContraceptivePage widget here
                          ),
                        );
                      },
                    );
                  },
                  child: CardContain(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // To space out the text and button
                          children: [
                            Text(
                              "Ovulation",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Container(
                                        child:
                                            OvulationScreen(), // Your ContraceptivePage widget here
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.arrow_forward_ios_rounded),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              //  height: 50,
                              //width: 100,
                              decoration: BoxDecoration(
                                color: Color(0xFF5EB1E7),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/ovulation/pos.svg",
                                    height: 15,
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Positive",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              //  height: 50,
                              //width: 100,
                              decoration: BoxDecoration(
                                color: Color(0xFF5EB1E7),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/ovulation/neg.svg",
                                    height: 20,
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Negative",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                //medicine
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContraceptivePage()));
                  },
                  child: CardContain(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // To space out the text and button
                          children: [
                            Text(
                              "Medicine",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: Image(image: AssetImage("assets/pill.png")),
                                ),

                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ContraceptivePage()));
                                  },
                                  icon: Icon(Icons.arrow_forward_ios_rounded),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                //water
                GestureDetector(
                  onTap: () {
                    AnalyticsService.logEvent("navigate_to_water_reminder", parameters: {
                      "from_screen": "My Cycle",
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WaterReminderScreen()));
                  },
                  child: CardContain(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // To space out the text and button
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Water Intake",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: Icon(Icons.settings),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              WaterReminderScreen(),
                                        ));
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: Image(image: AssetImage("assets/water.png")),
                                ),

                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WaterReminderScreen()));
                                  },
                                  icon: Icon(Icons.arrow_forward_ios_rounded),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                BannerAdWidget(),
                SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

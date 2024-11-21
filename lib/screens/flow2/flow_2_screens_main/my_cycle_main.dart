import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/screens/flow2/detail%20page/cycle/notes.dart';
import 'package:calender_app/screens/settings/settings_page.dart';
import 'package:calender_app/widgets/date_format.dart';
import 'package:calender_app/widgets/flow2_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
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

class CycleTrackerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<CycleProvider>(context);

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
        appBar: CustomAppBar(
          pageTitle: "Today",
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
                const SizedBox(height: 20),
                PeriodButtons(),
                const SizedBox(height: 20),
                FlowSection(),
                const SizedBox(height: 20),

                CycleInfoCard(
                  title: "My Cycles",
                  subtitle: "${cycleProvider.totalCyclesLogged} cycles logged", // Dynamic subtitle
                  progressLabelStart: formatDate(cycleProvider.lastPeriodStart),
                  progressLabelEnd: formatDate(cycleProvider.getNextPeriodDate()),
                  progressValue: (cycleProvider.daysElapsed / cycleProvider.cycleLength).clamp(0.0, 1.0),
                  click: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyCyclesScreen()),
                    );
                  },
                ),

                const SizedBox(height: 20),
                NoteSection(),

                const SizedBox(height: 40),
                CategorySection(
                  title: "Intercourse",
                  folderName: "intercourse",
                  targetPage: IntercourseScreen(),
                ),
                CategorySection(
                  title: "Symptoms",
                  folderName: "symptoms",
                  targetPage: Symptoms(),
                ),
                CategorySection(
                  title: "Moods",
                  folderName: "emoji",
                  targetPage: moods(),
                ),
                CardContain(
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
                            onPressed: ()  {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Container(
                                    child: OvulationScreen(), // Your ContraceptivePage widget here
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                CardContain(
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
                          IconButton(
                            onPressed: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => ContraceptivePage()));
                            },

                            icon: Icon(Icons.arrow_forward_ios_rounded),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SvgPicture.asset("assets/ovulation/drug.svg"),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                WaterIntakeSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

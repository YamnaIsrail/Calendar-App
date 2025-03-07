import 'package:calender_app/kegel_excercise/kegel_excercise_home.dart';
import 'package:calender_app/screens/flow2/detail%20page/self_care/foot.dart';
import 'package:calender_app/screens/flow2/detail%20page/self_care/pain_relief.dart';
import 'package:calender_app/screens/flow2/detail%20page/self_care/sound_track.dart';
import 'package:flutter/material.dart';

import '../../../kegel_excercise/kegel_excercises_pro/kegelDaysUnlocked_hive.dart';
import '../../../admob/banner_ad.dart';
import 'package:calender_app/firebase/analytics/analytics_service.dart';

class SelfCare extends StatelessWidget {
  const SelfCare({super.key});

  @override
  Widget build(BuildContext context) {
    int unlockedDay = KegelStorage.unlockedDay; // Get unlocked day from Hive
    AnalyticsService.logScreenView("SelfCareScreen");

    return Scaffold(
      appBar: AppBar(
        title: Text("Self Care"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFE8EAF6),
                Color(0xFFF3E5F5)
              ], // Light gradient background
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Menstrual Cramps Relief",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff3E579A)),
              ),
              GestureDetector(
                onTap: () {
                  AnalyticsService.logEvent("Navigate to Menstrual Cramps Relief Excercise", parameters: {
                    "from_screen": "SelfCareScreen",
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => painRelief()), // Replace with your page
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 180,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/self_care/pain_relief.png'),

                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withOpacity(0.3), // Adjust opacity as needed
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Period \npain relief',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15,),
              GestureDetector(
                onTap: () {
                  AnalyticsService.logEvent("Navigate_to_foot_massage", parameters: {
                    "from_screen": "SelfCareScreen",
                  });     Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => foot()), // Replace with your page
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 180,
                  child: Stack(
                    children: [
                      // Background Image
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/self_care/massage1.png'),
                            fit: BoxFit.cover,
                            alignment: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFCFDCFF)
                              .withOpacity(0.3), // Adjust opacity as needed
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Foot Massage to\n relieve cramps',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: () {
                  AnalyticsService.logEvent("navigate_to_kegel_exercises", parameters: {
                    "from_screen": "SelfCareScreen",
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KegelExercisesScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  width: double.infinity,

                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Color.fromRGBO(250, 152, 211, 1),
                      width: 1,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment(1, 0),
                      end: Alignment(0, 1),
                      colors: [
                        Color.fromRGBO(241, 65, 170, 0.48),
                        Color.fromRGBO(235, 29, 152, 0.11),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Kegel Exercises',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 10),

                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => KegelExercisesScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFEB1D98),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                minimumSize: const Size(150, 50), // Full width with minimum height
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.play_arrow_sharp, color: Colors.white, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    'Day $unlockedDay',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Image.asset(
                          "assets/kegel/flower2.png",
                                 ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Soundscapes",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff3E579A),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      AnalyticsService.logEvent("play_sound_forest_rain", parameters: {
                        "from_screen": "SelfCareScreen",
                        "sound": "Forest Rain",
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Sound(
                            audioPath:'assets/audios/calm.mp3',
                            title: 'Forest Rain',
                          ),
                        ),
                      );
                    },
                    child: _buildSoundButton('Forest Rain', 'assets/self_care/forest1.png'),
                  ),
                  GestureDetector(
                    onTap: () {
                      AnalyticsService.logEvent("play_sound_calm", parameters: {
                        "from_screen": "SelfCareScreen",
                        "sound": "Calm",
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Sound(
                            audioPath: 'assets/audios/birds.mp3',
                            title: 'Calm',
                          ),
                        ),
                      );
                    },
                    child: _buildSoundButton('Calm', 'assets/self_care/calm.png'),
                  ),
                ],
              ),
              BannerAdWidget(),
              SizedBox(height: 12),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSoundButton(String title, String imagePath) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Stack(
        children: [
          Container(
            height: 75,
            width: double.infinity,

            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                    height: 55,
                  width: 55,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child:Icon(Icons.play_arrow),

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

import 'package:calender_app/kegel_excercise/kegel_excercises_pro/kegelDaysUnlocked_hive.dart';
import 'package:calender_app/kegel_excercise/kegel_questionaire_flow/kegel_screen1.dart';
import 'package:calender_app/screens/flow2/home_flow2.dart';
import 'package:flutter/material.dart';
import 'kegel_excercises_pro/day_intro.dart';

class KegelExercisesScreen extends StatelessWidget {
  const KegelExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        // Handle back button press
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Flow2Page()), // Replace with your desired screen
        );
        return false; // Prevent default back navigation
      },
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromRGBO(250, 152, 211, 1),
                  width: 1,
                ),
                gradient: LinearGradient(
                  begin: Alignment(1, 0),
                  end: Alignment(0, 1),
                  colors: [
                    Color.fromRGBO(241, 65, 170, 0.48),
                    Color.fromRGBO(235, 29, 152, 0.11)
                  ],
                ),
              ),
              width: double.maxFinite,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                height: 152,
                width: 393,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Kegel Exercises',
                      style: TextStyle(
                        fontFamily: 'Roboto', // Default Material font
                        fontWeight: FontWeight.w600, // Similar to Semi-Bold
                        fontSize: 20,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Image.asset(
                        "assets/kegel/flower2.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => IntroScreen()));
              },
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.all(2.5),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xffAED2F6), Color(0xffEBA5CF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: ListTile(
                        title: Text(
                          'Exercise Tips',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        leading: Icon(
                          Icons.lightbulb,
                          color: Colors.yellow,
                          size: 19,
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => IntroScreen()));
                          },
                          icon: Icon(
                            Icons.keyboard_double_arrow_right,
                            size: 19,
                            color: Colors.blueAccent,
                          ),
                        )),
                  )),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 28,
                itemBuilder: (context, index) {
                  return ExerciseDayTile(day: index + 1);

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


int calculateDuration(int day) {
  if (day <= 7) return 3;
  if (day <= 12) return 4;
  if (day <= 16) return 5;
  if (day <= 22) return 6;
  return 7;
}

int calculateTotalCount(int day) {
  int totalCount = 40; // Start at 40
  List<int> increments = [
    2, 1, 2, 3, 2, 2, // Increments for days 2-7
    2, 2, 0, 4, -2,   // Increments for days 8-12
    4, 2, 2, 0,       // Increments for days 13-16
    3, 1, -1, 3, 1, -1, // Increments for days 17-22
    3, 0, 3, 0, 2, 2  // Increments for days 23-28
  ];

  for (int i = 2; i <= day; i++) {
    totalCount += increments[i - 2]; // Adjust based on the pattern
  }

  return totalCount;
}

class ExerciseDayTile extends StatelessWidget {
  final int day;
  final int duration;
  final int totalCount;

  ExerciseDayTile({required this.day})
      : duration = calculateDuration(day),
        totalCount = calculateTotalCount(day);

  @override
  Widget build(BuildContext context) {
    int unlockedDay = KegelStorage.unlockedDay; // Get unlocked day from Hive
    bool isUnlocked = day <= unlockedDay; // Unlock days <= current unlocked day
    bool isLatestUnlockedDay = day == unlockedDay;
// print("$day $totalCount");
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress line
        Column(
          children: [
            // Circle indicator for each day
            Container(
              height: 20,
              width: 20,
              child: Icon(
                Icons.circle,
                color: Colors.white,
                size: 14,
              ),
              margin: EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                color: isUnlocked ? Colors.pink : Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 5),
              height:
                  isLatestUnlockedDay ? 110 : 60, // Line height between days
              width: 2,
              color: isUnlocked
                  ? Colors.pink
                  : Colors.grey, // Yellow for unlocked days
            ),
          ],
        ),
        SizedBox(width: 5),

        // The exercise details
        Expanded(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  title: Text('Day $day'),
                  subtitle: Text('$duration min'),
                  trailing: isUnlocked
                      ? IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExcerciseDayScreen(
                                    duration: duration,
                                    totalcount: totalCount,
                                    day: day,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_forward_ios),
                        )
                      : const Icon(Icons.lock),
                ),
                if (isLatestUnlockedDay)
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    width: MediaQuery.of(context).size.width *
                        0.5, // 70% of the screen width
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExcerciseDayScreen(
                                totalcount: totalCount,
                                  duration: duration,
                                  day: day),
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFEB1D98),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        minimumSize: const Size(double.infinity,
                            50), // Full width with minimum height
                      ),
                      child: ListTile(
                        title: Text(
                          'Start',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600, // Similar to Semi-Bold
                            fontSize: 18,
                          ),
                        ),
                        leading: Icon(Icons.play_arrow_sharp, color: Colors.white, size: 18,),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

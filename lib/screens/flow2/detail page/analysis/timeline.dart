  import 'package:calender_app/hive/cycle_model.dart';
  import 'package:calender_app/hive/medicine_model.dart';
  import 'package:calender_app/hive/notes_model.dart';
import 'package:calender_app/notifications/notification_storage.dart';
  import 'package:calender_app/provider/app_state_provider.dart';
import 'package:calender_app/provider/moods_symptoms_provider.dart';
import 'package:calender_app/provider/notes_provider.dart';
  import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

  class TimeLine extends StatelessWidget {
    const TimeLine({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("TimeLine"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,  // Remove shadow for a cleaner gradient effect
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
          child: ListView(
            shrinkWrap: true, // Adjust height to content size
            physics: NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            children: [
              // First Card
              Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      // Date Container
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Wed", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                            Text("16", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            Text("Oct", style: TextStyle(fontSize: 16, color: Colors.black54)),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      // Content Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Note", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                            SizedBox(height: 4),
                            Text("I have to take medicine at 2:00 pm."),
                          ],
                        ),
                      ),
                      // Icon
                      Icon(Icons.favorite, color: Colors.pink),
                    ],
                  ),
                ),
              ),
              // Second Card
              Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      // Date Container
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.pink[100],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Thu", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                            Text("15", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            Text("Oct", style: TextStyle(fontSize: 16, color: Colors.black54)),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      // Content Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Symptoms", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                            SizedBox(height: 4),
                            Text("Diarrhea"),
                            SizedBox(height: 4),
                            Text("Water Intake: 1350 ml", style: TextStyle(color: Colors.blue)),
                          ],
                        ),
                      ),
                      // Icon
                      Icon(Icons.favorite, color: Colors.pink),
                    ],
                  ),
                ),
              ),
              // Third Card
              Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      // Date Container
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.purple[100],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Wed", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                            Text("03", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            Text("Oct", style: TextStyle(fontSize: 16, color: Colors.black54)),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      // Content Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Period Starts", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                          ],
                        ),
                      ),
                      // Icon
                      Icon(Icons.favorite, color: Colors.pink),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  class TimeLineCheck extends StatelessWidget {
    const TimeLineCheck({super.key});

    @override
    Widget build(BuildContext context) {
      final noteProvider = Provider.of<NoteProvider>(context);
      final reminder = NotificationStorage.getNotifications(); // Assuming this works
      final moodsProvider = Provider.of<MoodsProvider>(context);
      final symptomsProvider = Provider.of<SymptomsProvider>(context);

      return Scaffold(
        appBar: AppBar(
          title: Text("TimeLine"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0, // Remove shadow for a cleaner gradient effect
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFE8EAF6),
                  Color(0xFFF3E5F5),
                ], // Light gradient background
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: ListView(
            shrinkWrap: true, // Adjust height to content size
            physics: NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            children: [
              // First Card - Note
              Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      // Date Container for Notes
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              noteProvider.notesWithDates.isNotEmpty
                                  ? noteProvider.notesWithDates.last.date.weekday.toString()
                                  : "Wed",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              noteProvider.notesWithDates.isNotEmpty
                                  ? noteProvider.notesWithDates.last.date.day.toString()
                                  : "16",
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              noteProvider.notesWithDates.isNotEmpty
                                  ? noteProvider.notesWithDates.last.date.month.toString()
                                  : "Oct",
                              style: TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      // Content Column for Notes
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Note",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                            ),
                            SizedBox(height: 4),
                            Text(
                              noteProvider.notesWithDates.isNotEmpty
                                  ? noteProvider.notesWithDates.last.content
                                  : "Your notes appear here",
                            ),
                          ],
                        ),
                      ),
                      // Icon
                      Icon(Icons.favorite, color: Colors.pink),
                    ],
                  ),
                ),
              ),

              // Second Card - Symptoms
              Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      // Date Container for Symptoms
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.pink[100],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              symptomsProvider.recentSymptoms.isNotEmpty
                                  ? symptomsProvider.recentSymptoms.last['label'] ?? "Symptom"
                                  : "Thu",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              symptomsProvider.recentSymptoms.isNotEmpty
                                  ? symptomsProvider.recentSymptoms.last['label'] ?? "15"
                                  : "15",
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              symptomsProvider.recentSymptoms.isNotEmpty
                                  ? symptomsProvider.recentSymptoms.last['label'] ?? "Oct"
                                  : "Oct",
                              style: TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      // Content Column for Symptoms
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Symptoms",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                            ),
                            SizedBox(height: 4),
                            Text(
                              symptomsProvider.recentSymptoms.isNotEmpty
                                  ? symptomsProvider.recentSymptoms.last['label'] ?? "No symptoms recorded"
                                  : "No symptoms recorded",
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Water Intake: 0 ml",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      // Icon
                      Icon(Icons.favorite, color: Colors.pink),
                    ],
                  ),
                ),
              ),


              // Third  Card - Moods
              Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      // Date Container for Symptoms
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.pink[100],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              moodsProvider.recentMoods.isNotEmpty
                                  ?  moodsProvider.recentMoods.last['label'] ?? "Symptom"
                                  : "Thu",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              moodsProvider.recentMoods.isNotEmpty
                                  ?  moodsProvider.recentMoods.last['label'] ?? "15"
                                  : "15",
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              moodsProvider.recentMoods.isNotEmpty
                                  ?  moodsProvider.recentMoods.last['label'] ?? "Oct"
                                  : "Oct",
                              style: TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      // Content Column for Symptoms
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Moods",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                            ),
                            SizedBox(height: 4),
                            Text(
                              moodsProvider.recentMoods.isNotEmpty
                                  ?  moodsProvider.recentMoods.last['label'] ?? "No symptoms recorded"
                                  : "No Moods Added",
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Water Intake: 0 ml",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      // Icon
                      Icon(Icons.favorite, color: Colors.pink),
                    ],
                  ),
                ),
              ),


              // Fourth  Card - Reminders
              Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      // Date Container for Symptoms
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.pink[100],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              moodsProvider.recentMoods.isNotEmpty
                                  ?  moodsProvider.recentMoods.last['label'] ?? "Symptom"
                                  : "Thu",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              moodsProvider.recentMoods.isNotEmpty
                                  ?  moodsProvider.recentMoods.last['label'] ?? "15"
                                  : "15",
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              moodsProvider.recentMoods.isNotEmpty
                                  ?  moodsProvider.recentMoods.last['label'] ?? "Oct"
                                  : "Oct",
                              style: TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      // Content Column for Symptoms
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Moods",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                            ),
                            SizedBox(height: 4),
                            Text(
                              moodsProvider.recentMoods.isNotEmpty
                                  ?  moodsProvider.recentMoods.last['label'] ?? "No symptoms recorded"
                                  : "No Moods Added",
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Water Intake: 0 ml",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      // Icon
                      Icon(Icons.favorite, color: Colors.pink),
                    ],
                  ),
                ),
              ),


            ],
          ),
        ),
      );
    }
  }





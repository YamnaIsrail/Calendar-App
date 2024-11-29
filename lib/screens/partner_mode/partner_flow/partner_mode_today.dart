//be2e48
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';
import 'partner_mode_setting.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PregnancyStatusScreen extends StatelessWidget {
  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<CycleProvider>(context);

    final partnerProvider = Provider.of<PartnerProvider>(context);

    final lastMenstrualPeriod = partnerProvider.lastMenstrualPeriod;

    final cyclePhase= cycleProvider.currentPhase;

    final dueDate = partnerProvider.dueDate;
    final currentWeek = partnerProvider.getCurrentWeek();
    final daysUntilDueDate = partnerProvider.getDaysUntilDueDate();

    bool isInfoAvailable = lastMenstrualPeriod != DateTime.now() && dueDate != DateTime.now().add(Duration(days: 280));

    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Pregnancy Status"),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PartnerModeSetting()),
              );
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: isInfoAvailable
              ? Column(
            children: [
              Container(
                height: 280,
                width: 280,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/cal.png"),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text(
                      cyclePhase,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    Text(

                      "Cycle day is ${cycleProvider.daysElapsed} ",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),

                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      buildCycleInfoCard(
                        icon: Icons.baby_changing_station,
                        title: 'Week $currentWeek Progress',
                        subtitle: daysUntilDueDate < 0
                            ? 'Your baby is overdue. Contact your doctor!'
                            : 'Your pregnancy is progressing smoothly.',
                        progressLabelStart: "Week 1",
                        progressLabelEnd: "Week 40",
                        progressValue: currentWeek / 40,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
              : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Information is missing.",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                     },
                  child: Text("Add Pregnancy Info"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCycleInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String progressLabelStart,
    required String progressLabelEnd,
    required double progressValue,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.blueGrey,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text(progressLabelStart),
              Expanded(
                child: LinearProgressIndicator(
                  value: progressValue,
                  color: Colors.blue,
                  backgroundColor: Colors.grey[300],
                ),
              ),
              Text(progressLabelEnd),
            ],
          ),
        ],
      ),
    );
  }
}
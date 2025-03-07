import 'package:calender_app/provider/analysis/temperature_provider.dart';
import 'package:calender_app/provider/analysis/weight_provider.dart';
import 'package:calender_app/provider/date_day_format.dart';
import 'package:calender_app/screens/flow2/detail%20page/analysis/timeline.dart';
import 'package:calender_app/screens/flow2/detail%20page/analysis/weight_screens.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:calender_app/widgets/contain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../firebase/analytics/analytics_service.dart';
import '../detail page/analysis/temperature.dart';
import '../../../admob/banner_ad.dart';

class Analysis extends StatelessWidget {
   Analysis({super.key});

  @override
  Widget build(BuildContext context) {
    AnalyticsService.logScreenView("AnalysisScreen");

    final temperatureProvider = Provider.of<TemperatureProvider>(context);
    String latestTemperature = temperatureProvider.temperatureData.isNotEmpty
        ? "${temperatureProvider.getLatestTemperature()} °C"
        : "Not Entered Yet";

    final latestWeight =  Provider.of<WeightProvider>(context).latestWeight;
    final latestDate =  Provider.of<WeightProvider>(context).latestDate;

    return Scaffold(
      backgroundColor: Color(0xFFE8EAF6),
      appBar: AppBar(
        title: Text("Analysis"),
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
        scrollDirection: Axis.vertical,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(

              image: AssetImage('assets/bg.jpg'),
              fit: BoxFit.cover,
            ),
            gradient: LinearGradient(
              colors: [Color(0xFFE8EAF6), Color(0xFFF3E5F5)], // Light gradient background
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
         // padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

            Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/Weight.png',
                      width: 26,
                      height: 26,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Weight",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        latestWeight != null ? "${latestWeight!} Kg" : "No weight recorded",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        latestDate != null
                            ? DateFormat(context.watch<SettingsModel>().dateFormat).format(latestDate!)
                            : " ",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: Container(
                    width: 189,
                    height: 37,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(207, 220, 255, 1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: CustomButton2(
                      onPressed: () {
                        AnalyticsService.logEvent("navigate_to_add_weight", parameters: {
                          "from_screen": "AnalysisScreen",
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Weight()),
                        );
                      },
                      text: "Add Weight",
                    ),
                  ),
                ),
              ],
            ),
          ),

              SizedBox(height: 20,),

              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/Cold.png', // Replace with your actual image path
                          width: 26,
                          height: 26,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Temperature",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 26),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            latestTemperature,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            temperatureProvider.temperatureData.isNotEmpty
                                ? DateFormat(context.watch<SettingsModel>().dateFormat).format(DateTime.parse(
                                temperatureProvider.getLatestTemperatureDate()))
                                : "",
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: Container(
                        width: 189,
                        height: 37,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(207, 220, 255, 1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: CustomButton2(

                          onPressed: () {
                            AnalyticsService.logEvent("navigate_to_add_temperature", parameters: {
                              "from_screen": "AnalysisScreen",
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TempChart()),
                            );
                          },
                          text: "Add Temperature",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),


              Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                  leading: Image.asset(
                    'assets/icons/Timeline.png', // Replace with your actual image path
                    width: 34,
                    height: 34,
                  ),
                  title: Text(
                    "TimeLine",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      AnalyticsService.logEvent("navigate_to_timeline", parameters: {
                        "from_screen": "AnalysisScreen",
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TimelinePage()),
                      );
                    },
                    icon: Icon(Icons.arrow_forward_ios_rounded),
                  ),
                  onTap: () {
                    AnalyticsService.logEvent("navigate_to_timeline", parameters: {
                      "from_screen": "AnalysisScreen",
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TimelinePage()),
                    );
                  },
                )

              ),
              BannerAdWidget(),
              SizedBox(height: 12),


            ],
          )
        ),
      ),
    );
  }
}

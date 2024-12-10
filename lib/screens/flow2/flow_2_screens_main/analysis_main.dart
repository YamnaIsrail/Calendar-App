import 'package:calender_app/image_check.dart';
import 'package:calender_app/provider/analysis/temperature_provider.dart';
import 'package:calender_app/provider/analysis/weight_provider.dart';
import 'package:calender_app/screens/flow2/detail%20page/analysis/timeline.dart';
import 'package:calender_app/screens/flow2/detail%20page/analysis/weight_screens.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:calender_app/widgets/contain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../detail page/analysis/temperature.dart';

class Analysis extends StatelessWidget {
   Analysis({super.key});

  @override
  Widget build(BuildContext context) {
    final weightProvider = Provider.of<WeightProvider>(context);
    final lastWeightData = Provider.of<WeightProvider>(context).getLastWeightData();

    final temperatureProvider = Provider.of<TemperatureProvider>(context);
    String latestTemperature = temperatureProvider.temperatureData.isNotEmpty
        ? "${temperatureProvider.getLatestTemperature()} °F"
        : "Not Entered Yet";


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
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.monitor_weight_rounded, size: 34,),
                      label:  Text("Weight",   style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)
                      ),
                    ),
                    SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: lastWeightData == null
                          ? const Center(child: Text('No weight data available'))
                          :Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${lastWeightData!['weight']} kg',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)

                               ),
                          const SizedBox(height: 10),
                          Text(
                              DateFormat('MM/dd/yyyy').format(lastWeightData['date']),
                              style: const TextStyle(fontSize: 16),
                          ),
                       ],
                      ),
                    ),
                    SizedBox(height: 20,),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      margin:  const EdgeInsets.symmetric(horizontal: 20),

                    child: CustomButton2(
                            onPressed: (){
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (
                                          context)=> Weight()));

                            },
                            text: "Add Weight"
                        )
                    ),

                  ],
                ),
              ),
              SizedBox(height: 20,),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.monitor_weight_rounded, size: 34,),
                      label:  Text("Temperature",   style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)
                      ),
                    ),
                    SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          Text(latestTemperature,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          Text( temperatureProvider.temperatureData.isNotEmpty
                              ? DateFormat('yyyy-MM-dd').format(DateTime.parse(
                              temperatureProvider.getLatestTemperatureDate()))
                              : ""),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      margin:  const EdgeInsets.symmetric(horizontal: 20),

                    child: CustomButton2(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> TempChart()));

                            },
                            text: "Add Temperature"
                        )
                    ),

                  ],
                ),
              ),

              SizedBox(height: 20,),


              Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                color: Colors.white,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.access_alarm),
                      label:  Text("TimeLine",   style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)
                      ),
                    ),

                    IconButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> TimelinePage()));
                    },
                        icon: Icon(Icons.arrow_forward_ios_rounded))
                  ],
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}

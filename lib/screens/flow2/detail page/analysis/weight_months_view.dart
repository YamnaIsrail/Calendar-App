import 'package:calender_app/screens/flow2/detail%20page/analysis/weight_week_view.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'progress_bar.dart';

class MonthWeight extends StatelessWidget {
  const MonthWeight({super.key});

  @override
  Widget build(BuildContext context) {
    return  bgContainer(
      child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Weight", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Color(0xFFFFC4E8),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(Icons.arrow_back),
          ),
          onPressed: () => Navigator.pop(context),
        ),

      ),
      body: ListView(
 scrollDirection: Axis.vertical,
          children: [
            const SizedBox(height: 10),
            Container(
              height: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(15),
              child: LineChart(
                LineChartData(
                  minY: 60,
                  maxY: 75,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) => Text("Day ${(value + 1).toInt()}"),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) => Text("${value.toInt()} kg"),
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 65),
                        const FlSpot(1, 66),
                        const FlSpot(2, 67),
                        const FlSpot(3, 65),
                      ],
                      isCurved: true,
                        belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.withOpacity(0.5),
                            Colors.blue.withOpacity(0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Divider(),
            Container(
              padding: EdgeInsets.all(20),
              // height: 80,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton2(text: "Month",
                                 backgroundColor: secondaryColor,
                                 onPressed: () {
                                Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (context) => MonthWeight()));
                                },),
                  ),

                  SizedBox(width: 15,),
                  Expanded(
                    child: CustomButton2(text: "Week",
                      backgroundColor: primaryColor,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => weekWeight()));
                      },),
                  ),

                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Oct 23",
                    style:
                    TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text("65 kg",
                    style:
                    TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xffC6E1FC),
                borderRadius: BorderRadius.circular(12),
              ),

              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ListTile(
                    title: Text("BMI", style: TextStyle(fontSize: 18)),
                    trailing: Switch(value: true, onChanged: (value){}),  ),
                  Text("Moderately Obese", style: TextStyle(color:Colors.orange, fontSize: 11, fontWeight: FontWeight.bold)),

                  Container(
child: MultiColorProgressBar(progress: 6)
                  ),
SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Height ",
                          style: TextStyle(color:Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),

                      Text(" 5'3.0\" ft + in.",
                          style: TextStyle(color:Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),


      ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

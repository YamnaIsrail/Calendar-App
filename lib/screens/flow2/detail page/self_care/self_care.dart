import 'package:calender_app/screens/flow2/detail%20page/self_care/foot.dart';
import 'package:calender_app/screens/flow2/detail%20page/self_care/pain_relief.dart';
import 'package:flutter/material.dart';

class SelfCare extends StatelessWidget {
  const SelfCare({super.key});

  @override
  Widget build(BuildContext context) {
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
                  // Navigate to the next page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => painRelief()), // Replace with your page
                  );
                },
                child: Container(
                  width: 370,
                  height: 180,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/self_care/cramps_relief.png'), // Replace with your image path
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
              GestureDetector(
                onTap: () {
                  // Navigate to the next page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => foot()), // Replace with your page
                  );
                },
                child: Container(
                  width: 370,
                  height: 180,
                  child: Stack(
                    children: [
                      // Background Image
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/self_care/Foot-Massage.png'), // Replace with your image path
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
              Text(
                "Soundscapes",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff3E579A)),
              ),
              GestureDetector(
                onTap: () {

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => NextPage()), // Replace with your page
                  // );
                },
                child: Container(
                  // width: 370,
                  // height: 180,
                  child: Stack(
                    children: [
                      // Background Image
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/self_care/forest1.png'), // Replace with your image path
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Forest Rain',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.play_arrow))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => NextPage()), // Replace with your page
                  // );
                },
                child: Container(
                  // width: 370,
                  // height: 180,
                  child: Stack(
                    children: [
                      // Background Image
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/self_care/calm.png'), // Replace with your image path
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Forest Rain',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.all(5),
                                color: Colors.white,
                                child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.play_arrow)))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              top: -50,
              left: 160,
              child: Container(
                height: 200,
                width: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFEB1D98).withOpacity(0.5),

                      Color(0xFFffff).withOpacity(0.5),
                    ]
                  ),
                  ),
              ),
            ),
            Positioned(
              bottom: 170,
              left: 160,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFE710).withOpacity(0.5),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: 160,
              child: Container(
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFAFD1F3).withOpacity(0.5),
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: AssetImage("img.png"), height: 234, width: 345,),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFEB1D98),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(double.infinity, 50), // Expand to full width with a minimum height

                      ),
                      onPressed: ()
                      {
                       // Navigator.push(context, MaterialPageRoute(builder: (context)=>question1()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text.rich(
                            textAlign: TextAlign.center,
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Let's start\n", // First line with a newline
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16, // Increased font size for the first line
                                  fontWeight: FontWeight.bold, // Bold style for the first line
                                ),
                              ),
                              TextSpan(
                                text: "I am a new member",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14, // Normal font size for the second line
                                ),
                              ),
                            ],

                          )
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFC6E1FC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(double.infinity, 50), // Expand to full width with a minimum height

                      ),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text.rich(
                            textAlign: TextAlign.center,
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Partner mode \n", // First line with a newline
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16, // Increased font size for the first line
                                    fontWeight: FontWeight.bold, // Bold style for the first line
                                  ),
                                ),
                                TextSpan(
                                  text: "I have an invitation code",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14, // Normal font size for the second line
                                  ),
                                ),
                              ],

                            )
                        ),
                      ),
                    ),
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

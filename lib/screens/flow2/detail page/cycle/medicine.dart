import 'package:calender_app/screens/globals.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/buttons.dart';
import 'medicine_reminder/medicine_reminder_form.dart';

class ContraceptivePage extends StatelessWidget {
  // List of contraceptive methods with their names and corresponding icons
  final List<Map<String, dynamic>> contraceptives = [
    {'name': 'Contraceptives', 'icon': Icons.add_circle}, // Replace with your desired icon

    {'name': 'V-Ring', 'icon': Icons.circle}, // Replace with your desired icon
    {'name': 'Patch', 'icon': Icons.adjust},  // Replace with your desired icon
    {'name': 'Injection', 'icon': Icons.local_hospital}, // Replace with your desired icon
    {'name': 'IUD', 'icon': Icons.medical_services}, // Replace with your desired icon
    {'name': 'Implant', 'icon': Icons.pause}, // Replace with your desired icon
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Heading for the page
            Text(
              'Choose Your Contraceptive',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20), // Space between heading and items

            // Displaying contraceptive methods with their icons
            Expanded(
              child: ListView.builder(
                itemCount: contraceptives.length,
                itemBuilder: (context, index) {
                  final contraceptive = contraceptives[index];
                  return ListTile(
                    leading: Icon(
                      contraceptive['icon'], // Using icons instead of images
                      size: 40,  // Adjust the size as needed
                      color: Color(0xff3049B2), // Adjust the color of the icon
                    ),
                    title: Text(
                      contraceptive['name']!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20),
            CustomButton(
              backgroundColor: primaryColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MedicineReminderScreen()),
                );
              },
              text: 'Choose',
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../widgets/buttons.dart';


class ContraceptivePage extends StatelessWidget {
  // List of contraceptive methods with their icons/images (network URLs in this case)
  final List<Map<String, String>> contraceptives = [
    {'name': 'V-Ring', 'image': 'https://www.example.com/vring_image.png'},
    {'name': 'Patch', 'image': 'https://www.example.com/patch_image.png'},
    {'name': 'Injection', 'image': 'https://www.example.com/injection_image.png'},
    {'name': 'IUD', 'image': 'https://www.example.com/iud_image.png'},
    {'name': 'Implant', 'image': 'https://www.example.com/implant_image.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contraceptive Methods'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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

            // Displaying contraceptive methods with their images/icons
            Expanded(
              child: ListView.builder(
                itemCount: contraceptives.length,
                itemBuilder: (context, index) {
                  final contraceptive = contraceptives[index];
                  return ListTile(
                    leading: Image.network(
                      contraceptive['image']!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
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

            SizedBox(height: 20), // Space between items and button

            // Choose button
            ElevatedButton(
              onPressed: () {
                // Handle the "Choose" action here
                // For example, show a dialog or navigate to another screen
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Contraceptive Chosen'),
                    content: Text('You have successfully selected a contraceptive method.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Choose'),
            ),

            CustomButton(

              onPressed: () {
                // Handle the "Choose" action here
                // For example, show a dialog or navigate to another screen
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Contraceptive Chosen'),
                    content: Text('You have successfully selected a contraceptive method.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              }, text: 'Choose',
            )
          ],
        ),
      ),
    );
  }
}

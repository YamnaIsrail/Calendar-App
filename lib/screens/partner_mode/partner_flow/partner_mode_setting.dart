import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:calender_app/widgets/contain.dart';
import 'package:flutter/material.dart';

class PartnerModeSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Settings', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardContain(
              child: Column(
                children: [
                  Text(
                    'Paired for',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '1 Day',
                        style: TextStyle(fontSize: 30, color: Colors.blue),
                      ),
                      SizedBox(width: 16),
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://example.com/path-to-avatar.jpg'), // Replace with actual image URL
                        radius: 20,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),

            Text(
              'General Setting',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            CardContain(
              child: ListTile(
                leading: Icon(Icons.broken_image_sharp, color: primaryColor,),
                trailing: IconButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder:
                      (context)=>UnpairDialog()
                  )
                  );

                }, icon: Icon(Icons.arrow_forward_ios)),

                title: Text(
                  'Stop pairing',
                  style: TextStyle(fontSize: 16, ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => UnpairDialog(),
                  );
                },

              ),
            ),
          ],
        ),
      ),
    );
  }
}
class UnpairDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Unpair with your partner?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'If you stop, you will no longer receive your partner’s period updates and pregnancy-related information.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                text: 'Cancel',
                backgroundColor: Colors.grey, // Replace with `greyBlueColor`
              ),
              CustomButton(
                onPressed: () {
                  // Action for unpairing
                },
                text: 'Unpair',
                backgroundColor: Colors.pink, // Replace with `primaryColor`
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/provider/paired_days_provider.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/screens/partner_mode/partner_flow/stop_pairing_dialog.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:calender_app/widgets/contain.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:calender_app/provider/partner_provider.dart';
class PartnerModeSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text('Settings', style: TextStyle(color: Colors.black)),
          leading: IconButton(
            icon: Icon(Icons.close, color: Colors.black),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Paired for',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Text(
                          '${PairedDaysProvider().daysPaired}',
                          style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        SizedBox(width: 16),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              child: Icon(Icons.boy),
                            ),
                             CircleAvatar(
                             radius: 20,
                              child: Icon(Icons.girl),

                            ),
                          ],
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
                    StopPairingDialogHelper.unpairPopUp(context);

                  }, icon: Icon(Icons.arrow_forward_ios)),
                  onTap: () {
                    StopPairingDialogHelper.unpairPopUp(context);
                  },
                  title: Text(
                    'Stop pairing',
                    style: TextStyle(fontSize: 16, ),
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

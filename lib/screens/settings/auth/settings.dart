import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bgContainer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Settings', style: TextStyle(fontSize: 24)),
              SwitchListTile(
                title: Text('Enable Fingerprint'),
                value: true,
                onChanged: (value) {},
              ),
              SwitchListTile(
                title: Text('Enable PIN'),
                value: false,
                onChanged: (value) {},
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: () {}, child: Text('Change PIN')),
              ElevatedButton(onPressed: () {}, child: Text('Change Password')),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.pink[100],
        actions: [
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () {
              // Sync data functionality here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserProfileSection(),
              GoalSection(),
              SettingsOptionSection(),
              AdditionalOptionsSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class UserProfileSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/profile.jpg'), // Replace with actual image
      ),
      title: Text("Sign in and Synchronize your data"),
      trailing: ElevatedButton(
        onPressed: () {
          // Sync data functionality here
        },
        child: Text("Sync Data"),
      ),
    );
  }
}

class GoalSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Text(
            "My Goal",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GoalCard(title: "Track my period", days: "4 days"),
            GoalCard(title: "Track my pregnancy", days: "28 days"),
          ],
        ),
      ],
    );
  }
}

class GoalCard extends StatelessWidget {
  final String title;
  final String days;

  GoalCard({required this.title, required this.days});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.pink[50],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            days,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class SettingsOptionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Repeat similar structure for each option
        SettingsOption(icon: Icons.notifications, title: "Reminders"),
        SettingsOption(icon: Icons.backup, title: "Backup & Restore"),
        SettingsOption(icon: Icons.lock, title: "Password"),
        // Add more options as needed
      ],
    );
  }
}

class SettingsOption extends StatelessWidget {
  final IconData icon;
  final String title;

  SettingsOption({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.pink),
      title: Text(title),
      onTap: () {
        // Navigate or handle setting option
      },
    );
  }
}

class AdditionalOptionsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text("FAQ"),
          onTap: () {
            // Navigate to FAQ section
          },
        ),
        ListTile(
          title: Text("Privacy"),
          onTap: () {
            // Navigate to Privacy section
          },
        ),
        // Add more options as needed
      ],
    );
  }
}

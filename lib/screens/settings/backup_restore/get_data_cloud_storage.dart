import 'package:calender_app/firebase/user_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> uploadBackupToFirestore(String uid, String data) async {
  try {
    CollectionReference backups = FirebaseFirestore.instance.collection('backups');
    await backups.doc(uid).set({
      'backupData': data, // Store the backup data under 'backupData' field
      'timestamp': FieldValue.serverTimestamp(), // Optional: store timestamp of backup
    });
    //print("Backup uploaded to Firestore.");
  } catch (e) {
    //print("Upload failed: $e");
  }
}

Future<String?> fetchBackupFromFirestore(String uid) async {
  try {
    // Reference to the specific user's document
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('backups').doc(uid).get();
    if (snapshot.exists) {
      // Get the backup data from the document
      String data = snapshot['backupData'];
      //print("Backup retrieved from Firestore.");
      return data;
    } else {
      //print("No backup data available.");
      return null;
    }
  } catch (e) {
    //print("Error retrieving data: $e");
    return null;
  }
}

void handleGoogleRecovery(BuildContext context) async {
  final userId = await SessionManager.getUserId();
  if (userId == null) {
    //print("No user ID found. Cannot recover.");
    return;
  }

  // Fetch backup data from Firestore
  String? recoveryData = await fetchBackupFromFirestore(userId);

  if (recoveryData != null) {
    // Restore user data from `recoveryData`
    //print("Restoring user data...");
    // Example: Decode/deserialize data here
  } else {
    //print("No backup data available.");
  }
}

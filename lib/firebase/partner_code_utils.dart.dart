
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

// Helper function to generate a unique code
String _generateUniqueCode() {
  return Uuid().v4().substring(0, 6); // Generate a random 6-character code
}

Future<void> generatePartnerCode() async {
  if (FirebaseAuth.instance.currentUser != null) {
    final user = FirebaseAuth.instance.currentUser;
    final partnerCode = _generateUniqueCode();

    try {
      // Save the partner code to Firestore for User 1 with expiration as Timestamp
      final expiresAt = Timestamp.fromDate(DateTime.now().add(Duration(days: 30)));
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'partnerCode': partnerCode,
        'expiresAt': expiresAt, // Store as Timestamp
      });
      print("Partner code generated: $partnerCode");
    } catch (e) {
      print("Error generating partner code: $e");
    }
  } else {
    print("User not signed in");
  }
}

Future<bool> validatePartnerCode(BuildContext context, String enteredCode) async {

  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('partnerCode', isEqualTo: enteredCode)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final partnerData = snapshot.docs.first.data();
      var expirationField = partnerData['expiresAt'];

      DateTime expirationTime;

      if (expirationField is Timestamp) {
        expirationTime = expirationField.toDate();
      } else if (expirationField is String) {
        expirationTime = DateTime.parse(expirationField);
      } else {
        // Handle the case where expirationField is neither Timestamp nor String
        print("Unexpected type for expiresAt field");
        return false;
      }

      if (DateTime.now().isAfter(expirationTime)) {
        return false; // Expired code
      }

      // Save user1 ID (the partner code generator) to user2's document
      String user1Id = snapshot.docs.first.id;

      // Now pass the user1Id to PartnerProvider to fetch cycle data
      final partnerProvider = Provider.of<PartnerProvider>(context, listen: false);
      await partnerProvider.fetchUser1CycleData(user1Id);  // Pass the user1Id here

      return true; // Valid code
    } else {
      return false; // Invalid code
    }
  } catch (e) {
    print("Error validating partner code: $e");
    return false;
  }
}

Future<void> validateAndGetCycleData(String enteredCode) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('partnerCode', isEqualTo: enteredCode)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Data found, retrieve the cycle data
      final partnerData = snapshot.docs.first.data();
      final partnerUid = snapshot.docs.first.id;

      // Retrieve cycle data from the cycles collection
      final cycleSnapshot = await FirebaseFirestore.instance
          .collection('cycles')
          .doc(partnerUid)
          .get();

      if (cycleSnapshot.exists) {
        final cycleData = cycleSnapshot.data();
        if (cycleData != null) {
          print("Cycle data: $cycleData");
        } else {
          print("Cycle data is null.");
        }
      } else {
        print("No cycle data found for this partner.");
      }
    } else {
      print("Invalid partner code or expired.");
    }
  } catch (e) {
    print("Error retrieving partner data: $e");
  }
}

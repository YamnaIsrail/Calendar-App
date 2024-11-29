import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> storeUserData(User user, int cycleLength, int periodDays, DateTime lastPeriodDate) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

  // Set the user data
  await userRef.set({
    'cycleLength': cycleLength,
    'periodDays': periodDays,
    'lastPeriodDate': lastPeriodDate,
    'partnerCode': generatePartnerCode(),  // You can generate this code here
  });
}

String generatePartnerCode() {
  // Generate a unique code for the partner (e.g., based on current time or random string)
  return DateTime.now().millisecondsSinceEpoch.toString();
}


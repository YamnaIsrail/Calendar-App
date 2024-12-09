import 'package:calender_app/firebase/partner_code_utils.dart.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:share_plus/share_plus.dart';

class ShareCodeScreen extends StatefulWidget {
  @override
  _ShareCodeScreenState createState() => _ShareCodeScreenState();
}

class _ShareCodeScreenState extends State<ShareCodeScreen> {
  String? code;
  String? expiryTime;
  @override
  void initState() {
    super.initState();
    _generateCode();
  }

  String _generateUniqueCode() {
    return Uuid().v4().substring(0, 6); // Generate a random 6-character code
  }
  Future<void> _generateCode() async {
    final generatedCode = _generateUniqueCode();
    final expiration = DateTime.now().add(Duration(hours: 24)).toIso8601String();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      await userRef.set({
        'partnerCode': generatedCode,
        'expiresAt': expiration,
        'userId': user.uid,
      });

      setState(() {
        code = generatedCode;
        expiryTime = DateTime.now().add(Duration(hours: 24)).toLocal().toString().split(' ')[1];
      });
    }
    }

  void _copyToClipboard(BuildContext context) {
    if (code != null) {
      Clipboard.setData(ClipboardData(text: code!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Code copied to clipboard!')),
      );
    }
  }

  void _shareCode(BuildContext context) {
    if (code != null) {
      Share.share('Here is the invitation code for Partner Mode: $code');
    }
  }

  @override
  Widget build(BuildContext context) {
    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "Partner Mode",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(35),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/partner_mode/Isolation_Mode.svg"),
                SizedBox(height: 30),
                Text(
                  'Share your invitation code',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'The code is valid for 24 hours',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                if (code != null) ...[
                  Text(
                    '$code',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'The code expires at $expiryTime',
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CustomButton(
                          backgroundColor: primaryColor,
                          onPressed: () => _copyToClipboard(context),
                          text: "Copy Code",
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: CustomButton(
                          backgroundColor: primaryColor,
                          onPressed: () => _shareCode(context),
                          text: "Share Code",
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  CustomButton(
                    backgroundColor: primaryColor,
                    onPressed: _generateCode,
                    text: "Generate Code",
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class ShareCodeScreen extends StatelessWidget {
//   final String code = Uuid().v4().substring(0, 6);
//
//   Future<void> _storeCode() async {
//     final box = Hive.box('partner_codes');
//     box.put(
//       code,
//       {
//         'expiresAt': DateTime.now().add(Duration(hours: 24)).toIso8601String(),
//       },
//     );
//   }
//   void _copyToClipboard(BuildContext context) {
//     Clipboard.setData(ClipboardData(text: code));
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Code copied to clipboard!')),
//     );
//   }
//
//   void _shareCode(BuildContext context) {
//     Share.share('Here is the invitation code for Partner Mode: $code');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     _storeCode(); // Store code when screen is built
//     return bgContainer(
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           title: Text(
//             "Partner Mode",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
//           ),
//           centerTitle: true,
//           backgroundColor: Colors.transparent,
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(35),
//           child: Center(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SvgPicture.asset("assets/partner_mode/Isolation_Mode.svg"),
//                 SizedBox(height: 30),
//                 Text(
//                   'Share your invitation code',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'The code is valid for 24 hours',
//                   style: TextStyle(fontSize: 14),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 30),
//                 Text(
//                   '$code',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: primaryColor,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'The code expires at ${DateTime.now().add(Duration(hours: 24)).toLocal().toString().split(' ')[1]}',
//                   style: TextStyle(fontSize: 12),
//              //     textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 30),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       child: CustomButton(
//                         backgroundColor: primaryColor,
//                         onPressed: () => _copyToClipboard(context),
//                         text: "Copy Code",
//                       ),
//                     ),
//                     SizedBox(width: 5,),
//                     Expanded(
//                       child: CustomButton(
//                         backgroundColor: primaryColor,
//                         onPressed: () => _shareCode(context),
//                         text: "Share Code",
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


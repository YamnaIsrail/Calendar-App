import 'package:calender_app/firebase/partner_code_utils.dart.dart';
import 'package:calender_app/provider/cycle_provider.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:share_plus/share_plus.dart';

class ShareCodeScreen extends StatefulWidget {
  @override
  _ShareCodeScreenState createState() => _ShareCodeScreenState();
}

class _ShareCodeScreenState extends State<ShareCodeScreen> {
  bool isLoading = false; // Track loading state


  String? code;
  String? expiryTime;
  @override
  void initState() {
    super.initState();
    _generateCode();
  }

  String _generateUniqueCode() {
    return Uuid().v4().substring(0, 6);
  }
  Future<void> _generateCode() async {
    setState(() {
      isLoading = true; // Start loading
    });

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
      // Upload cycle data to Firestore (this will be called when the code is generated)
      await Provider.of<CycleProvider>(context, listen: false).saveCycleDataToFirestore();

      setState(() {
        code = generatedCode;
        expiryTime = DateTime.now().add(Duration(hours: 24)).toLocal().toString().split(' ')[1];
      });
    }
    setState(() {
      isLoading = false; // Stop loading
    });

  }

  void _copyToClipboard(BuildContext context) {
    if (code != null) {
      Clipboard.setData(ClipboardData(text: code!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Code copied to clipboard!')),
      );
    }
  }

  Future<void> _shareCode(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final appLink =
        'https://play.google.com/store/apps/details?id=${packageInfo.packageName}&hl=en';

    if (code != null) {
      Share.share(
          'To view your partner’s details, first download the app: $appLink. '
              'Here is your invitation code for Partner Mode: $code');
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
                  'The code is valid for 24 hours \n or until you generated a new code ',
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
                    text: isLoading ? "Loading .." :"Generate Code",
                  ),
                  SizedBox(height: 15,),
                  if (isLoading)
                    CircularProgressIndicator()
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}


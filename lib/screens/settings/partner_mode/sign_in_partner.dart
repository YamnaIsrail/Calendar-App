import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'partner_link_screen.dart';

// class PartnerModeSignInScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return bgContainer(
//         child: Scaffold(
//           backgroundColor: Colors.transparent,
//           appBar: AppBar(
//             title: Text(
//               "Partner Mode",
//               style: TextStyle(
//                    fontWeight: FontWeight.bold, fontSize: 27),
//             ),
//             centerTitle: true,
//             backgroundColor: Colors.transparent,
//           ),
//           body:  Padding(
//             padding: const EdgeInsets.all(35),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SvgPicture.asset("assets/partner_mode/Isolation_Mode.svg"),
//                 SizedBox(height: 30),
//
//                 Text(
//                   'A tap to cloud sync,\n'
//                       ' a step closer to partner',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 10),
//
//                 Text(
//                   'Real-time cloud sync ensures a more '
//                       'private and convenient experience for both of you.'
//                       ' To access it, please sign in first.',
//                   style: TextStyle(fontSize: 14,),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 30),
//                 CustomButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => PartnerLinkScreen()),
//                     );
//
//                   },
//                   text: "Sign in with Google",
//                   backgroundColor: Colors.blueAccent,
//
//                 ),
//
//               ],
//             ),
//           ),
//         ));
//   }
// }

import 'package:google_sign_in/google_sign_in.dart';

class PartnerModeSignInScreen extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        // Successfully signed in
        print('User Name: ${account.displayName}');
        print('User Email: ${account.email}');

        // Navigate to PartnerLinkScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PartnerLinkScreen()),
        );
      } else {
        // User canceled the sign-in process
        print('Sign-in canceled by user');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-in required to access Partner Mode.')),
        );
      }
    } catch (error) {
      print('Google Sign-In Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed. Please try again.')),
      );
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/partner_mode/Isolation_Mode.svg"),
              SizedBox(height: 30),
              Text(
                'A tap to cloud sync,\n'
                    'a step closer to partner',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Real-time cloud sync ensures a more '
                    'private and convenient experience for both of you.'
                    ' To access it, please sign in first.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              CustomButton(
                onPressed: () => _handleGoogleSignIn(context),
                text: "Sign in with Google",
                backgroundColor: Colors.blueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

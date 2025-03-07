import 'package:calender_app/auth/auth_provider.dart';
import 'package:calender_app/screens/globals.dart';
import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:calender_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'create_pin.dart';
import 'enter_password.dart';
import 'package:local_auth/local_auth.dart';


class CreatePasswordScreen extends StatefulWidget {
  @override
  _CreatePasswordScreenState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final LocalAuthentication _auth = LocalAuthentication();

  String _selectedSecurityQuestion = '';

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _securityAnswerController = TextEditingController();

  Future<void> _authenticateWithFingerprint() async {
    bool authenticated = await _auth.authenticate(
      localizedReason: 'Please authenticate to proceed',
      options: AuthenticationOptions(
        stickyAuth: true,
        useErrorDialogs: true,
        biometricOnly: true,
      ),
    );
    if (authenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fingerprint authentication successful")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fingerprint authentication failed")),
      );
    }
  }

  void _savePassword() {
    if (_passwordController.text == _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password saved successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
    }
  }

  void _savePin() {
    // Implement PIN save functionality here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PIN saved successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return bgContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Password"),
          backgroundColor: Colors.transparent,
          centerTitle: true,
        ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Security Question Selection
            Text('Password'),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text('Confirm Password'),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Confirm your password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),


            SizedBox(height: 20),
            Text('Select Security Question'),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(),
             //   color: Colors.white,
              ),
              child: DropdownButton<String>(
                value: _selectedSecurityQuestion.isEmpty ? null : _selectedSecurityQuestion,
                hint: Text("Select a security question"),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSecurityQuestion = newValue!;
                  });
                },
                items: <String>[
                  'What is your pet\'s name?',
                  'What was the name of your first school?',
                  'What is your mother\'s maiden name?',
                  'What is your favorite color?'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),

            // Security Answer Input
            SizedBox(height: 20),
            Text('Answer'),
            TextField(
              controller: _securityAnswerController,
              decoration: InputDecoration(
                hintText: 'Enter the answer to your security question',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),


            // Fingerprint Option
            SizedBox(height: 20),

            // Save Button
            SizedBox(height: 20),
            CustomButton(
              onPressed: () {
                if (_passwordController.text == _confirmPasswordController.text) {
                  Provider.of<AuthProvider>(context, listen: false).savePassword(_passwordController.text);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password saved successfully")));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Passwords do not match")));
                }
              },
              text: 'Save',
              backgroundColor: primaryColor,
            ),

          ],
        ),
      ),
    ));
  }
}



// class CreatePasswordScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return  bgContainer(
//
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           title: Text("Password"),
//           backgroundColor: Colors.transparent,
//           centerTitle: true,
//         ),
//         body: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             scrollDirection: Axis.vertical,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                  Text('Password', style: TextStyle(fontSize: 16)),
//                 TextField(
//
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     helperText: 'Only use letters, numbers, and symbols.',
//                     helperStyle: TextStyle(fontSize: 12, color: Colors.grey),
//
//                     hintText: '',  // Empty hint text
//                     filled: true,
//                     fillColor: Colors.white,  // White background
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),  // Rounded corners
//                       borderSide: BorderSide.none,  // No border line
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Text('Confirm Password', style: TextStyle(fontSize: 16)),
//                 TextField(
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     hintText: '',  // Empty hint text
//                     filled: true,
//                     fillColor: Colors.white,  // White background
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),  // Rounded corners
//                       borderSide: BorderSide.none,  // No border line
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                   Text('Email', style: TextStyle(fontSize: 16)),
//                 TextField(
//                   decoration: InputDecoration(
//                     helperText: 'Email is required for the purpose of backing up your password.',
//                     helperStyle: TextStyle(fontSize: 12, color: Colors.grey),
//
//                     hintText: '',
//                     filled: true,
//                     fillColor: Colors.white,  // White background
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),  // Rounded corners
//                       borderSide: BorderSide.none,  // No border line
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 // Security Question TextField with label above
//                 Text('Security Question', style: TextStyle(fontSize: 16)),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//
//                     borderRadius: BorderRadius.circular(12),  // Rounded corners
//                   ),
//                   child: ExpansionTile(
//                     title: Text('__Select__'),
//                     children: [
//                       ListTile(
//                         title: Text('What is your pet\'s name?'),
//                         onTap: () {
//                           // Handle selection here
//                         },
//                       ),
//                       ListTile(
//                         title: Text('What was the name of your first school?'),
//                         onTap: () {
//                           // Handle selection here
//                         },
//                       ),
//                       ListTile(
//                         title: Text('What is your mother\'s maiden name?'),
//                         onTap: () {
//                           // Handle selection here
//                         },
//                       ),
//                       ListTile(
//                         title: Text('What is your favorite color?'),
//                         onTap: () {
//                           // Handle selection here
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 SizedBox(height: 16),
//                 // Answer TextField with label above
//                 Text('Answer', style: TextStyle(fontSize: 16)),
//                 TextField(
//                   controller: TextEditingController(text: 'Fluffy'),  // Default value
//                   decoration: InputDecoration(
//                     hintText: '',  // Empty hint text
//                     filled: true,
//                     fillColor: Colors.white,  // White background
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),  // Rounded corners
//                       borderSide: BorderSide.none,  // No border line
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 CustomButton(
//                   backgroundColor: primaryColor,
//                   onPressed: () {
//
//                     Navigator.push(context, MaterialPageRoute(builder: (context)=> EnterPasswordScreen()));
//                   },
//                    text: 'Save',
//
//
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Privacy Policy",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
           Text(
              '''Thank you for choosing Period & Ovulation Tracker. We value your privacy and are committed to protecting the personal information you share with us. This Privacy Policy explains how we collect, use, and share your information when you use our app, which tracks menstrual and pregnancy data and provides related health information.

By using our app, you consent to the collection and use of your personal information in accordance with this policy. Please read this policy carefully.

''',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "1. Information We Collect:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '''- Personal Information: When you register for an account or use our services, we collect personal information such as your name, email address, and other details that you provide.
- Health Data: We collect data related to your menstrual cycles, pregnancy tracking, period lengths, cycle start and end dates, and other health-related metrics.
- Device Information: We may collect data about the device you are using, including device type, operating system, and app version.
- Cookies and Tracking Technologies: Our app uses cookies and similar tracking technologies to enhance user experience and collect data about usage patterns.
''',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "2. How We Use Your Information:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '''We use the information we collect to:
- Track your menstrual and pregnancy cycles.
- Provide health insights based on your tracked data.
- Improve the functionality and user experience of the app.
- Communicate with you regarding your account and our services.
- Ensure the security and proper functioning of the app.
''',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "3. Sharing of Information:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '''We do not sell, rent, or share your personal information with third parties, except in the following cases:
- Service Providers: We may share your information with trusted third-party service providers who assist in the operation of our app, such as cloud storage providers.
- Legal Requirements: We may disclose your information if required to do so by law or in response to valid legal requests, such as subpoenas or court orders.
''',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "4. Data Security:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '''We take appropriate security measures to protect your personal information from unauthorized access, alteration, disclosure, or destruction. However, no method of data transmission over the internet or electronic storage is 100% secure, so we cannot guarantee absolute security.
''',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "5. Your Rights and Choices:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '''- Access and Update: You have the right to access, update, or delete your personal information at any time through your account settings.
- Data Retention: We retain your information for as long as necessary to fulfill the purposes outlined in this Privacy Policy or as required by law.
- Opt-Out: You can opt out of receiving marketing communications from us by following the unsubscribe instructions included in our emails.
''',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "6. Changes to This Privacy Policy:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '''We may update this Privacy Policy from time to time. We will notify you of any significant changes by posting the updated policy within the app and updating the effective date at the top of the policy. Please review this policy periodically to stay informed about how we are protecting your information.
''',
              style: TextStyle(fontSize: 16),
            ),

          ],
        ),
      ),
    );
  }
}

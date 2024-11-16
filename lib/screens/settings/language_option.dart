import 'package:calender_app/widgets/backgroundcontainer.dart';
import 'package:flutter/material.dart';

class LanguageOptionScreen extends StatefulWidget {
  @override
  _LanguageOptionScreenState createState() => _LanguageOptionScreenState();
}

class _LanguageOptionScreenState extends State<LanguageOptionScreen> {
  String? _selectedLanguage;

  final List<String> languages = [
    "English",
    "Spanish",
    "French",
    "German",
    "Italian",
    "Portuguese",
    "Russian",
    "Chinese (Simplified)",
    "Chinese (Traditional)",
    "Japanese",
    "Korean",
    "Hindi",
    "Arabic",
    "Turkish",
    "Dutch",
    "Urdu",
  ];

  @override
  Widget build(BuildContext context) {
    return bgContainer(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          "Language Options",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
        ),

        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: Colors.white,
            child: ListTile(
              title: Text(languages[index], style: TextStyle(fontWeight: FontWeight.bold),),
              trailing: Radio<String>(
                value: languages[index],
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                },
              ),
              onTap: () {
                setState(() {
                  _selectedLanguage = languages[index];
                });
              },
            ),
          );
        },
      ),
    ));
  }
}

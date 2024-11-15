import 'package:flutter/material.dart';

class LanguageOptionScreen extends StatefulWidget {
  @override
  _LanguageOptionScreenState createState() => _LanguageOptionScreenState();
}

class _LanguageOptionScreenState extends State<LanguageOptionScreen> {
  String? _selectedLanguage;

  final List<String> languages = [
    "English", "Spanish", "French", "German", "Italian",
    "Portuguese", "Russian", "Chinese (Simplified)",
    "Chinese (Traditional)", "Japanese", "Korean",
    "Hindi", "Arabic", "Turkish", "Dutch", "Urdu"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Language Options"),
        backgroundColor: Colors.pink,
      ),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          return RadioListTile<String>(
            title: Text(languages[index]),
            value: languages[index],
            groupValue: _selectedLanguage,
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value;
              });
            },
          );
        },
      ),
    );
  }
}

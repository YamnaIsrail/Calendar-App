import 'package:flutter/material.dart';
import 'translation.dart';  // Make sure to import the translation file
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class LanguageSelectionScreen extends StatefulWidget {

  final Function(String) onLanguageChanged; // Change this to accept a String
  LanguageSelectionScreen({required this.onLanguageChanged});

  @override
  _LanguageSelectionScreenState createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguage = "English"; // Default language

  // Language list with corresponding language codes
  List<Map<String, String>> languages = [
    {"name": "English", "code": "en"},
    {"name": "Spanish", "code": "es"},
    {"name": "French", "code": "fr"},
    // Add more languages here
  ];

  void _onLanguageSelected(Map<String, String> language) {
    setState(() {
      _selectedLanguage = language['name']!;
    });

    widget.onLanguageChanged(language['name']!);
    // After language selection, reload the app's texts with the new language
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Language'),
      ),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          return RadioListTile<String>(
            value: languages[index]['name']!,
            groupValue: _selectedLanguage,
            title: Text(languages[index]['name']!),
            onChanged: (value) {
              if (value != null) {
                _onLanguageSelected(languages[index]);
              }
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final Function(String) onLanguageChanged;

  LanguageSelectionScreen({required this.onLanguageChanged});

  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguage = "English"; // Default language

  List<Map<String, String>> languages = [
    {"name": "English", "code": "en"},
    {"name": "Spanish", "code": "es"},
    {"name": "French", "code": "fr"},
    {"name": "German", "code": "de"},
    {"name": "Italian", "code": "it"},
    {"name": "Portuguese", "code": "pt"},
    {"name": "Russian", "code": "ru"},
    {"name": "Chinese (Simplified)", "code": "zh-CN"},
    {"name": "Chinese (Traditional)", "code": "zh-TW"},
    {"name": "Japanese", "code": "ja"},
    {"name": "Korean", "code": "ko"},
    {"name": "Hindi", "code": "hi"},
    {"name": "Arabic", "code": "ar"},
    {"name": "Turkish", "code": "tr"},
    {"name": "Dutch", "code": "nl"},
    {"name": "Urdu", "code": "ur"},
  ];

  void _onLanguageSelected(Map<String, String> language) {
    setState(() {
      _selectedLanguage = language['name']!;
    });

    widget.onLanguageChanged(language['name']!);
    Navigator.pop(context);  // Close the language selection screen after selection
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

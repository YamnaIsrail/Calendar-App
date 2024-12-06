// import 'package:hive/hive.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import 'package:http/io_client.dart';
// import 'dart:io';
// import 'package:http/http.dart' as http;
//
// // Disable certificate verification (for testing purposes only)
// HttpClient client = HttpClient()
//   ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
//
// final ioClient = IOClient(client);
//
// Future<String> translateText(String text, String targetLang) async {
//   try {
//     final url = Uri.parse('https://libretranslate.de/translate');
//     final response = await ioClient.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'q': text,
//         'source': 'en',  // Default source language
//         'target': targetLang,
//         'format': 'text',
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       final responseBody = json.decode(response.body);
//       return responseBody['translatedText'];
//     } else {
//       throw Exception('Failed to load translation: ${response.body}');
//     }
//   } catch (e) {
//     throw Exception('Error while translating: $e');
//   }
// }
//
// Future<void> cacheTranslation(String languageCode, String originalText) async {
//   try {
//     // Check if translation is already cached
//     final cachedTranslation = await getCachedTranslation(originalText, languageCode);
//     if (cachedTranslation != originalText) {
//       // Translation is cached, no need to fetch again
//       return;
//     }
//
//     // If not cached, translate and store
//     String translated = await translateText(originalText, languageCode);
//     Box translationBox = await Hive.openBox('translations');
//     await translationBox.put(originalText + languageCode, translated);
//   } catch (e) {
//     print('Error while caching translation: $e');
//   }
// }
//
// // Retrieve cached translations
// Future<String> getCachedTranslation(String originalText, String languageCode) async {
//   try {
//     Box translationBox = await Hive.openBox('translations');
//     return translationBox.get(originalText + languageCode, defaultValue: originalText);
//   } catch (e) {
//     print('Error while fetching cached translation: $e');
//     return originalText;  // Return original text in case of an error
//   }
// }


import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class DynamicTranslation {
  final GoogleTranslator _translator = GoogleTranslator();

  Future<String> translateText(String text, String languageCode) async {
    var translation = await _translator.translate(text, to: languageCode);
    return translation.text;
  }
}

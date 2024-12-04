import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const _localizedValues = {
    'en': {
      'language': 'Language Options',
      'english': 'English',
      'spanish': 'Spanish',
      'french': 'French',
      'german': 'German',
      'italian': 'Italian',
      'portuguese': 'Portuguese',
      'russian': 'Russian',
      'chinese_simplified': 'Chinese (Simplified)',
      'chinese_traditional': 'Chinese (Traditional)',
      'japanese': 'Japanese',
      'korean': 'Korean',
      'hindi': 'Hindi',
      'arabic': 'Arabic',
      'turkish': 'Turkish',
      'dutch': 'Dutch',
      'urdu': 'Urdu',
    },
    // Add more languages as needed.
    'es': {
      'language': 'Opciones de idioma',
      'english': 'Inglés',
      'spanish': 'Español',
      'french': 'Francés',
      'german': 'Alemán',
      'italian': 'Italiano',
      'portuguese': 'Portugués',
      'russian': 'Ruso',
      'chinese_simplified': 'Chino (Simplificado)',
      'chinese_traditional': 'Chino (Tradicional)',
      'japanese': 'Japonés',
      'korean': 'Coreano',
      'hindi': 'Hindi',
      'arabic': 'Árabe',
      'turkish': 'Turco',
      'dutch': 'Neerlandés',
      'urdu': 'Urdu',
    },
    // Add more language mappings here...
  };

  String? translate(String key) {
    return _localizedValues[locale.languageCode]?[key];
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode); // Add other languages as needed

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

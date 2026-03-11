// ===============================================
// File: locale.dart
// Overview: Locale utilities for parsing, system locale, resolution, and display/English name maps.
//
// Sections:
//   - Constants
//   - Locale Parsing Functions
//   - System Locale Helpers
//   - Locale Resolution Callback
//   - Display Name Maps (Native & English)
// ===============================================

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

const kLanguageCodeInPreferences = 'language_code';
const kCountryCodeInPreferences = 'country_code';

/// parse the locale string to a [Locale] object
Locale localeParseString(String localeString) {
  final parts = localeString.split('_');
  if (parts.length == 2) {
    return Locale(parts[0], parts[1]);
  } else {
    return Locale(localeString);
  }
}

/// return the system locale of the app
Locale get localeSystem => localeParseString(Intl.systemLocale);

/// return is using the system locale
bool get localeIsSystem => Intl.defaultLocale == null || Intl.systemLocale == Intl.defaultLocale;

/// A function that returns the locale resolution callback for the app.
Locale? localeResolutionCallback(Locale? locale, Iterable<Locale> supportedLocales) {
  if (locale == null) {
    return const Locale('en'); // default to 'en'
  }

  // languageCode + countryCode
  for (var supportedLocale in supportedLocales) {
    if (supportedLocale.languageCode == locale.languageCode && supportedLocale.countryCode == locale.countryCode) {
      return supportedLocale;
    }
  }

  // only languageCode
  for (var supportedLocale in supportedLocales) {
    if (supportedLocale.languageCode == locale.languageCode) {
      return supportedLocale;
    }
  }

  // default 'en'
  return const Locale('en');
}

Map<String, String> localeDisplayLabels = {
  // A
  'ar': 'العربية', // Arabic

  // B
  'bn': 'বাংলা', // Bengali

  // D
  'de': 'Deutsch', // German

  // E
  'el': 'Ελληνικά', // Greek
  'en': 'English',
  'es': 'Español', // Spanish

  // F
  'fa': 'فارسی', // Persian
  'fr': 'Français', // French

  // H
  'he': 'עברית', // Hebrew
  'hi': 'हिन्दी', // Hindi
  'hu': 'Magyar', // Hungarian

  // I
  'id': 'Bahasa Indonesia', // Indonesian
  'it': 'Italiano', // Italian

  // J
  'ja': '日本語', // Japanese

  // K
  'ko': '한국어', // Korean

  // M
  'ms': 'Bahasa Melayu', // Malay
  'my': 'မြန်မာ', // Burmese

  // N
  'nl': 'Nederlands', // Dutch

  // P
  'pl': 'Polski', // Polish
  'pt': 'Português', // Portuguese (Brazil)

  // R
  'ro': 'Română', // Romanian
  'ru': 'Русский', // Russian

  // S
  'sr': 'Српски', // Serbian

  // T
  'th': 'ไทย', // Thai
  'tr': 'Türkçe', // Turkish

  // U
  'uk': 'Українська', // Ukrainian

  // V
  'vi': 'Tiếng Việt', // Vietnamese

  // Z
  'zh': '中文', // Chinese
  'zh_CN': '简体中文 (中国)', // Chinese Simplified (China)
};

Map<String, String> localeEngNames = {
  'ar': 'Arabic',
  'bn': 'Bengali',
  'de': 'German',
  'el': 'Greek',
  'en': 'English',
  'es': 'Spanish',
  'fa': 'Persian',
  'fr': 'French',
  'he': 'Hebrew',
  'hi': 'Hindi',
  'hu': 'Hungarian',
  'id': 'Indonesian',
  'it': 'Italian',
  'ja': 'Japanese',
  'ko': 'Korean',
  'ms': 'Malay',
  'my': 'Burmese',
  'nl': 'Dutch',
  'pl': 'Polish',
  'pt': 'Portuguese',
  'ro': 'Romanian',
  'ru': 'Russian',
  'sr': 'Serbian',
  'th': 'Thai',
  'tr': 'Turkish',
  'uk': 'Ukrainian',
  'vi': 'Vietnamese',
  'zh': 'Chinese',
  'zh_CN': 'Chinese (Simplified)',
};

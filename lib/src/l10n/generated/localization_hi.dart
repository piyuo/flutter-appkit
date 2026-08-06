// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class LocalizationHi extends Localization {
  LocalizationHi([String locale = 'hi']) : super(locale);

  @override
  String get error_content =>
      'एक अप्रत्याशित त्रुटि हुई। कृपया बाद में पुनः प्रयास करें।';

  @override
  String get error_oops => 'उफ़, कुछ गलत हो गया';

  @override
  String get language => 'सिस्टम भाषा';
}

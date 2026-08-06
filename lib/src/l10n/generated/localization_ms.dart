// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class LocalizationMs extends Localization {
  LocalizationMs([String locale = 'ms']) : super(locale);

  @override
  String get error_content =>
      'Ralat tidak dijangka telah berlaku. Sila cuba lagi nanti.';

  @override
  String get error_oops => 'Alamak, ada sesuatu yang tidak kena';

  @override
  String get language => 'Bahasa Sistem';
}

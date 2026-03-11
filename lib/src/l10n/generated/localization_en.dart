// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class LocalizationEn extends Localization {
  LocalizationEn([String locale = 'en']) : super(locale);

  @override
  String get close => 'Close';

  @override
  String get error_content =>
      'An unexpected error occurred. Please try again later.';

  @override
  String get error_oops => 'Oops, something went wrong';

  @override
  String get error_report => 'Help us improve by sending an anonymous report';

  @override
  String get language => 'System Language';
}

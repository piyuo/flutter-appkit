// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class LocalizationDa extends Localization {
  LocalizationDa([String locale = 'da']) : super(locale);

  @override
  String get close => 'Luk';

  @override
  String get error_content => 'Der opstod en uventet fejl. Prøv igen senere.';

  @override
  String get error_oops => 'Ups, noget gik galt';

  @override
  String get error_report =>
      'Hjælp os med at forbedre ved at sende en anonym rapport';

  @override
  String get language => 'Systemsprog';
}

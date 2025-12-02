// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class LocalizationNb extends Localization {
  LocalizationNb([String locale = 'nb']) : super(locale);

  @override
  String get close => 'Lukk';

  @override
  String get error_content => 'Det oppstod en uventet feil. Prøv igjen senere.';

  @override
  String get error_oops => 'Ups, noe gikk galt';

  @override
  String get error_report =>
      'Hjelp oss å bli bedre ved å sende en anonym rapport';

  @override
  String get language => 'Systemspråk';
}

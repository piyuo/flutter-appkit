// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class LocalizationDe extends Localization {
  LocalizationDe([String locale = 'de']) : super(locale);

  @override
  String get close => 'Schließen';

  @override
  String get error_content =>
      'Ein unerwarteter Fehler ist aufgetreten. Bitte versuchen Sie es später erneut.';

  @override
  String get error_oops => 'Hoppla, etwas ist schiefgelaufen';

  @override
  String get error_report =>
      'Helfen Sie uns zu verbessern, indem Sie einen anonymen Bericht senden';

  @override
  String get language => 'Systemsprache';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class LocalizationFr extends Localization {
  LocalizationFr([String locale = 'fr']) : super(locale);

  @override
  String get close => 'Fermer';

  @override
  String get error_content =>
      'Une erreur inattendue s\'est produite. Veuillez réessayer plus tard.';

  @override
  String get error_oops => 'Oups, quelque chose s\'est mal passé';

  @override
  String get error_report =>
      'Aidez-nous à nous améliorer en envoyant un rapport anonyme';

  @override
  String get language => 'Langue du système';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class LocalizationCa extends Localization {
  LocalizationCa([String locale = 'ca']) : super(locale);

  @override
  String get close => 'Tancar';

  @override
  String get error_content =>
      'S\'ha produït un error inesperat. Si us plau, torneu-ho a provar més tard.';

  @override
  String get error_oops => 'Vaja, alguna cosa ha anat malament';

  @override
  String get error_report => 'Ajudeu-nos a millorar enviant un informe anònim';

  @override
  String get language => 'Idioma del sistema';
}

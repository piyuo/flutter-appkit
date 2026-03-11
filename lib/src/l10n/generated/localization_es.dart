// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class LocalizationEs extends Localization {
  LocalizationEs([String locale = 'es']) : super(locale);

  @override
  String get close => 'Cerrar';

  @override
  String get error_content =>
      'Ocurrió un error inesperado. Por favor, inténtalo de nuevo más tarde.';

  @override
  String get error_oops => 'Ups, algo salió mal';

  @override
  String get error_report => 'Ayúdanos a mejorar enviando un informe anónimo';

  @override
  String get language => 'Idioma del sistema';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class LocalizationPt extends Localization {
  LocalizationPt([String locale = 'pt']) : super(locale);

  @override
  String get error_content =>
      'Ocorreu um erro inesperado. Por favor, tente novamente mais tarde.';

  @override
  String get error_oops => 'Ops, algo deu errado';

  @override
  String get language => 'Língua do sistema';
}

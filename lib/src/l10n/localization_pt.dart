// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class LocalizationPt extends Localization {
  LocalizationPt([String locale = 'pt']) : super(locale);

  @override
  String get close => 'Fechar';

  @override
  String get error_content =>
      'Ocorreu um erro inesperado. Por favor, tente novamente mais tarde.';

  @override
  String get error_oops => 'Ops, algo deu errado';

  @override
  String get error_report =>
      'Ajude-nos a melhorar enviando um relatório anônimo';

  @override
  String get language => 'Língua do sistema';
}

/// The translations for Portuguese, as used in Portugal (`pt_PT`).
class LocalizationPtPt extends LocalizationPt {
  LocalizationPtPt() : super('pt_PT');

  @override
  String get close => 'Fechar';

  @override
  String get error_content =>
      'Ocorreu um erro inesperado. Por favor, tente novamente mais tarde.';

  @override
  String get error_oops => 'Ups, algo correu mal';

  @override
  String get error_report =>
      'Ajude-nos a melhorar enviando um relatório anónimo';

  @override
  String get language => 'Língua do sistema';
}

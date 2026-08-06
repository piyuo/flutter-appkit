// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class LocalizationRu extends Localization {
  LocalizationRu([String locale = 'ru']) : super(locale);

  @override
  String get error_content =>
      'Произошла непредвиденная ошибка. Пожалуйста, попробуйте снова позже.';

  @override
  String get error_oops => 'Упс, что-то пошло не так';

  @override
  String get language => 'Язык системы';
}

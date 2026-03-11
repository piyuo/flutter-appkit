// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class LocalizationUk extends Localization {
  LocalizationUk([String locale = 'uk']) : super(locale);

  @override
  String get close => 'Закрити';

  @override
  String get error_content =>
      'Сталася неочікувана помилка. Будь ласка, спробуйте ще раз пізніше.';

  @override
  String get error_oops => 'Упс, щось пішло не так';

  @override
  String get error_report =>
      'Допоможіть нам покращитися, надіславши анонімний звіт';

  @override
  String get language => 'Мова системи';
}

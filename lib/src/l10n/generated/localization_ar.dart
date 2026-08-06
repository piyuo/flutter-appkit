// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class LocalizationAr extends Localization {
  LocalizationAr([String locale = 'ar']) : super(locale);

  @override
  String get error_content =>
      'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى لاحقاً.';

  @override
  String get error_oops => 'عفواً، حدث خطأ ما';

  @override
  String get language => 'لغة النظام';
}

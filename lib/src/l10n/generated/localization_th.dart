// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class LocalizationTh extends Localization {
  LocalizationTh([String locale = 'th']) : super(locale);

  @override
  String get error_content =>
      'เกิดข้อผิดพลาดที่ไม่คาดคิด โปรดลองใหม่อีกครั้งในภายหลัง';

  @override
  String get error_oops => 'อุปส์ มีบางอย่างผิดพลาด';

  @override
  String get language => 'ภาษาระบบ';
}

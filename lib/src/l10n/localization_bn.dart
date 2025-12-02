// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class LocalizationBn extends Localization {
  LocalizationBn([String locale = 'bn']) : super(locale);

  @override
  String get close => 'বন্ধ করুন';

  @override
  String get error_content =>
      'একটি অপ্রত্যাশিত ত্রুটি ঘটেছে। অনুগ্রহ করে পরে আবার চেষ্টা করুন।';

  @override
  String get error_oops => 'উফ, কিছু একটা ভুল হয়েছে';

  @override
  String get error_report =>
      'একটি অজ্ঞাত রিপোর্ট পাঠিয়ে আমাদের উন্নত করতে সাহায্য করুন';

  @override
  String get language => 'সিস্টেম ভাষা';
}

/// The translations for Bengali Bangla, as used in India (`bn_IN`).
class LocalizationBnIn extends LocalizationBn {
  LocalizationBnIn() : super('bn_IN');

  @override
  String get close => 'বন্ধ করুন';

  @override
  String get error_content =>
      'একটি অপ্রত্যাশিত ত্রুটি ঘটেছে। অনুগ্রহ করে পরে আবার চেষ্টা করুন।';

  @override
  String get error_oops => 'ওহো, কিছু একটা ভুল হয়েছে';

  @override
  String get error_report =>
      'একটি অজ্ঞাত রিপোর্ট পাঠিয়ে আমাদের উন্নত করতে সাহায্য করুন';

  @override
  String get language => 'সিস্টেম ভাষা';
}

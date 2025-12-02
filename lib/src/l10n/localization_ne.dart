// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Nepali (`ne`).
class LocalizationNe extends Localization {
  LocalizationNe([String locale = 'ne']) : super(locale);

  @override
  String get close => 'बन्द गर्नुहोस्';

  @override
  String get error_content =>
      'अनपेक्षित त्रुटि भयो। कृपया पछि फेरि प्रयास गर्नुहोस्।';

  @override
  String get error_oops => 'उफ्, केही गलत भयो';

  @override
  String get error_report =>
      'बेनामी रिपोर्ट पठाएर हामीलाई सुधार गर्न मद्दत गर्नुहोस्';

  @override
  String get language => 'प्रणाली भाषा';
}

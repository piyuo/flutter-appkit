// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class LocalizationZh extends Localization {
  LocalizationZh([String locale = 'zh']) : super(locale);

  @override
  String get error_content => '發生了意外錯誤。請稍後再試。';

  @override
  String get error_oops => '糟糕，出了點問題';

  @override
  String get language => '系統語言';
}

/// The translations for Chinese, as used in China (`zh_CN`).
class LocalizationZhCn extends LocalizationZh {
  LocalizationZhCn() : super('zh_CN');

  @override
  String get error_content => '发生了意外错误。请稍后重试。';

  @override
  String get error_oops => '糟糕，出错了';

  @override
  String get language => '系统语言';
}

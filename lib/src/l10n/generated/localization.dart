import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'localization_ar.dart' deferred as localization_ar;
import 'localization_bn.dart' deferred as localization_bn;
import 'localization_de.dart' deferred as localization_de;
import 'localization_el.dart' deferred as localization_el;
import 'localization_en.dart' deferred as localization_en;
import 'localization_es.dart' deferred as localization_es;
import 'localization_fa.dart' deferred as localization_fa;
import 'localization_fr.dart' deferred as localization_fr;
import 'localization_he.dart' deferred as localization_he;
import 'localization_hi.dart' deferred as localization_hi;
import 'localization_hu.dart' deferred as localization_hu;
import 'localization_id.dart' deferred as localization_id;
import 'localization_it.dart' deferred as localization_it;
import 'localization_ja.dart' deferred as localization_ja;
import 'localization_ko.dart' deferred as localization_ko;
import 'localization_ms.dart' deferred as localization_ms;
import 'localization_my.dart' deferred as localization_my;
import 'localization_nl.dart' deferred as localization_nl;
import 'localization_pl.dart' deferred as localization_pl;
import 'localization_pt.dart' deferred as localization_pt;
import 'localization_ro.dart' deferred as localization_ro;
import 'localization_ru.dart' deferred as localization_ru;
import 'localization_sr.dart' deferred as localization_sr;
import 'localization_th.dart' deferred as localization_th;
import 'localization_tr.dart' deferred as localization_tr;
import 'localization_uk.dart' deferred as localization_uk;
import 'localization_vi.dart' deferred as localization_vi;
import 'localization_zh.dart' deferred as localization_zh;

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of Localization
/// returned by `Localization.of(context)`.
///
/// Applications need to include `Localization.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/localization.dart';
///
/// return MaterialApp(
///   localizationsDelegates: Localization.localizationsDelegates,
///   supportedLocales: Localization.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the Localization.supportedLocales
/// property.
abstract class Localization {
  Localization(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static Localization of(BuildContext context) {
    return Localizations.of<Localization>(context, Localization)!;
  }

  static const LocalizationsDelegate<Localization> delegate =
      _LocalizationDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fa'),
    Locale('fr'),
    Locale('he'),
    Locale('hi'),
    Locale('hu'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('ms'),
    Locale('my'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ro'),
    Locale('ru'),
    Locale('sr'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('vi'),
    Locale('zh'),
    Locale('zh', 'CN')
  ];

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @error_content.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again later.'**
  String get error_content;

  /// No description provided for @error_oops.
  ///
  /// In en, this message translates to:
  /// **'Oops, something went wrong'**
  String get error_oops;

  /// No description provided for @error_report.
  ///
  /// In en, this message translates to:
  /// **'Help us improve by sending an anonymous report'**
  String get error_report;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'System Language'**
  String get language;
}

class _LocalizationDelegate extends LocalizationsDelegate<Localization> {
  const _LocalizationDelegate();

  @override
  Future<Localization> load(Locale locale) {
    return lookupLocalization(locale);
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'bn',
        'de',
        'el',
        'en',
        'es',
        'fa',
        'fr',
        'he',
        'hi',
        'hu',
        'id',
        'it',
        'ja',
        'ko',
        'ms',
        'my',
        'nl',
        'pl',
        'pt',
        'ro',
        'ru',
        'sr',
        'th',
        'tr',
        'uk',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_LocalizationDelegate old) => false;
}

Future<Localization> lookupLocalization(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'CN':
            return localization_zh
                .loadLibrary()
                .then((dynamic _) => localization_zh.LocalizationZhCn());
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return localization_ar
          .loadLibrary()
          .then((dynamic _) => localization_ar.LocalizationAr());
    case 'bn':
      return localization_bn
          .loadLibrary()
          .then((dynamic _) => localization_bn.LocalizationBn());
    case 'de':
      return localization_de
          .loadLibrary()
          .then((dynamic _) => localization_de.LocalizationDe());
    case 'el':
      return localization_el
          .loadLibrary()
          .then((dynamic _) => localization_el.LocalizationEl());
    case 'en':
      return localization_en
          .loadLibrary()
          .then((dynamic _) => localization_en.LocalizationEn());
    case 'es':
      return localization_es
          .loadLibrary()
          .then((dynamic _) => localization_es.LocalizationEs());
    case 'fa':
      return localization_fa
          .loadLibrary()
          .then((dynamic _) => localization_fa.LocalizationFa());
    case 'fr':
      return localization_fr
          .loadLibrary()
          .then((dynamic _) => localization_fr.LocalizationFr());
    case 'he':
      return localization_he
          .loadLibrary()
          .then((dynamic _) => localization_he.LocalizationHe());
    case 'hi':
      return localization_hi
          .loadLibrary()
          .then((dynamic _) => localization_hi.LocalizationHi());
    case 'hu':
      return localization_hu
          .loadLibrary()
          .then((dynamic _) => localization_hu.LocalizationHu());
    case 'id':
      return localization_id
          .loadLibrary()
          .then((dynamic _) => localization_id.LocalizationId());
    case 'it':
      return localization_it
          .loadLibrary()
          .then((dynamic _) => localization_it.LocalizationIt());
    case 'ja':
      return localization_ja
          .loadLibrary()
          .then((dynamic _) => localization_ja.LocalizationJa());
    case 'ko':
      return localization_ko
          .loadLibrary()
          .then((dynamic _) => localization_ko.LocalizationKo());
    case 'ms':
      return localization_ms
          .loadLibrary()
          .then((dynamic _) => localization_ms.LocalizationMs());
    case 'my':
      return localization_my
          .loadLibrary()
          .then((dynamic _) => localization_my.LocalizationMy());
    case 'nl':
      return localization_nl
          .loadLibrary()
          .then((dynamic _) => localization_nl.LocalizationNl());
    case 'pl':
      return localization_pl
          .loadLibrary()
          .then((dynamic _) => localization_pl.LocalizationPl());
    case 'pt':
      return localization_pt
          .loadLibrary()
          .then((dynamic _) => localization_pt.LocalizationPt());
    case 'ro':
      return localization_ro
          .loadLibrary()
          .then((dynamic _) => localization_ro.LocalizationRo());
    case 'ru':
      return localization_ru
          .loadLibrary()
          .then((dynamic _) => localization_ru.LocalizationRu());
    case 'sr':
      return localization_sr
          .loadLibrary()
          .then((dynamic _) => localization_sr.LocalizationSr());
    case 'th':
      return localization_th
          .loadLibrary()
          .then((dynamic _) => localization_th.LocalizationTh());
    case 'tr':
      return localization_tr
          .loadLibrary()
          .then((dynamic _) => localization_tr.LocalizationTr());
    case 'uk':
      return localization_uk
          .loadLibrary()
          .then((dynamic _) => localization_uk.LocalizationUk());
    case 'vi':
      return localization_vi
          .loadLibrary()
          .then((dynamic _) => localization_vi.LocalizationVi());
    case 'zh':
      return localization_zh
          .loadLibrary()
          .then((dynamic _) => localization_zh.LocalizationZh());
  }

  throw FlutterError(
      'Localization.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier for managing the app's locale.
///
/// Loads the locale from preferences on initialization, allows updating,
/// and persists changes. Also updates [Intl.defaultLocale].

@ProviderFor(LocaleNotifier)
final localeProvider = LocaleNotifierProvider._();

/// Notifier for managing the app's locale.
///
/// Loads the locale from preferences on initialization, allows updating,
/// and persists changes. Also updates [Intl.defaultLocale].
final class LocaleNotifierProvider
    extends $NotifierProvider<LocaleNotifier, Locale?> {
  /// Notifier for managing the app's locale.
  ///
  /// Loads the locale from preferences on initialization, allows updating,
  /// and persists changes. Also updates [Intl.defaultLocale].
  LocaleNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'localeProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$localeNotifierHash();

  @$internal
  @override
  LocaleNotifier create() => LocaleNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale?>(value),
    );
  }
}

String _$localeNotifierHash() => r'5b9d62131636fddb201193411915f14dee1fb317';

/// Notifier for managing the app's locale.
///
/// Loads the locale from preferences on initialization, allows updating,
/// and persists changes. Also updates [Intl.defaultLocale].

abstract class _$LocaleNotifier extends $Notifier<Locale?> {
  Locale? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Locale?, Locale?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Locale?, Locale?>, Locale?, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

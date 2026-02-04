// ===============================================
// Module: app.dart
// Description: Core initialization function for Flutter AppKit with comprehensive error handling
//
// Sections:
//   - Global State Variables
//   - Main appRun() Function
//   - Error Handler Setup
//   - Error Catching and Processing
//
// Features:
//   - Sentry integration (optional)
//   - Error callback for custom error handling
//   - Riverpod state management setup
//   - Multi-layer error handling
//   - Talker logging integration
//   - Error dialog management
// ===============================================

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_observer.dart';

import 'env.dart';
import 'locale_notifier.dart';
import 'logger.dart';
import 'show_error.dart';

/// Internal widget that watches the locale provider and rebuilds when locale changes
class _LocaleAwareApp extends ConsumerWidget {
  const _LocaleAwareApp({required this.suspect});

  final Widget Function(Locale?) suspect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return suspect(locale);
  }
}

// Cache the DSN validation result
bool? _sentryEnabledCache;

bool get isSentryEnabled {
  // In test mode, don't use cache to allow for environment changes
  if (kDebugMode) {
    final dsn = envGet('SENTRY_DSN');
    return dsn.isNotEmpty && _isValidSentryDSN(dsn);
  }

  if (_sentryEnabledCache != null) return _sentryEnabledCache!;

  final dsn = envGet('SENTRY_DSN');
  _sentryEnabledCache = dsn.isNotEmpty && _isValidSentryDSN(dsn);
  return _sentryEnabledCache!;
}

/// Initializes and runs a Flutter app with comprehensive error handling.
///
/// The [suspect] function should return the root widget of your application.
/// It receives a [Locale?] parameter that updates whenever the locale changes,
/// ensuring the app rebuilds when the user switches languages.
/// The optional [errorCallback] allows you to evaluate caught errors and decide
/// whether to suppress or display them to the user.
///
/// Sentry crash reporting is automatically enabled when SENTRY_DSN environment
/// variable is configured. App Hang tracking is disabled by default to protect
/// user's privacy, we must get user's permission in order to send sentry error report.
///
/// Features:
/// - Catches all unhandled exceptions
/// - Optional Sentry integration for crash reporting (with App Hang tracking disabled)
/// - Optional error callback for custom error handling
/// - Prevents multiple error dialogs
/// - Logs errors using Talker
/// - Riverpod state management setup
/// - Locale-aware widget rebuilding
///
/// Example:
/// ```dart
/// await appRun((locale) => MyApp(locale: locale));
///
/// // With error callback to suppress platform exceptions
/// await appRun((locale) => MyApp(locale: locale), errorCallback: (e) {
///   if (e is PlatformException || e is MissingPluginException) {
///     return false; // Don't show these errors to user
///   }
///   return true; // Show other errors
/// });
/// ```
Future<void> appRun(
  Widget Function(Locale?) suspect, {
  bool Function(Object)? errorCallback,
  bool observeRiverPod = true,
}) async {
  runZonedGuarded<Future<void>>(
    () async {
      // Load environment variables from .env file
      await envInit();
      final appContent = ProviderScope(observers: [
        if (observeRiverPod) TalkerRiverpodObserver(talker: talker),
      ], child: _LocaleAwareApp(suspect: suspect));

      _setupErrorHandlers(errorCallback);

      if (isSentryEnabled) {
        await _initWithSentry(appContent);
      } else {
        _initWithoutSentry(appContent);
      }
    },
    (Object e, StackTrace stack) => catched(e, stack, errorCallback),
  );
}

/// Initializes the app with Sentry integration
Future<void> _initWithSentry(Widget appContent) async {
  final sentryDSN = envGet('SENTRY_DSN');

  try {
    await SentryFlutter.init(
      (options) {
        options.dsn = sentryDSN;
        options.sendDefaultPii = true;
        // Reduce debug noise in console
        options.debug = false;
        // Disable App Hang tracking to to protect user's privacy,
        // we must get user's permission in order to send sentry error report.
        options.enableAppHangTracking = false;
        // Optional: Set log level to reduce warnings
        options.diagnosticLevel = SentryLevel.error;
        // Add environment detection
        options.environment = kDebugMode ? 'development' : 'production';
      },
      appRunner: () => runApp(SentryWidget(child: appContent)),
    );
    logInfo('Sentry is enabled.');
  } catch (e) {
    logWarning('Failed to initialize Sentry: $e. Falling back to basic error handling.');
    _initWithoutSentry(appContent);
  }
}

/// Initializes the app without Sentry
void _initWithoutSentry(Widget appContent) {
  logInfo('Sentry is not enabled. To use Sentry, provide a valid DSN in the SENTRY_DSN environment variable.');
  runApp(appContent);
}

/// Validates if the provided DSN is a valid Sentry DSN format
bool _isValidSentryDSN(String dsn) {
  if (dsn.isEmpty) return false;

  try {
    final uri = Uri.parse(dsn);
    // Enhanced validation for Sentry DSN format
    // Sentry DSNs typically follow: https://public_key@organization.ingest.sentry.io/project_id
    return uri.hasScheme &&
        uri.hasAuthority &&
        uri.pathSegments.isNotEmpty &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.contains('sentry.io'); // More specific Sentry validation
  } catch (e) {
    return false;
  }
}

void _setupErrorHandlers(bool Function(Object)? errorCallback) {
  final originalOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) async {
    await catched(details.exception, details.stack, errorCallback);
    originalOnError?.call(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    catched(error, stack, errorCallback);
    return true;
  };
}

@visibleForTesting
Future<void> catched(dynamic e, StackTrace? stack, [bool Function(Object)? errorCallback]) async {
  // Only ignore null errors for safety
  if (e == null) {
    return;
  }
  printErrorToConsole(e, stack);

  try {
    // Check if callback is provided and evaluate whether to show error
    bool shouldShowError = true;
    if (errorCallback != null) {
      shouldShowError = errorCallback(e);
    }

    // Only show error dialog if callback allows it
    if (shouldShowError) {
      final reportAnonymously = await showError(e, stack);
      if (reportAnonymously) {
        sendErrorToSentry(e, stack);
      }
    }
  } catch (ex) {
    // Log the error and also print to console for debugging
    debugPrint('Error dialog display failed: $ex');
  }
}

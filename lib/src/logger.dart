// ===============================================
// Module: logger.dart
// Description: Logging utilities with Talker integration and Sentry reporting
//
// Sections:
//   - Imports and Talker Instance
//   - Console Display Function
//   - Logging Utility Functions
//     - debug(String) - Debug level logging
//     - info(String) - Info level logging
//     - warning(String) - Warning level logging
//     - critical(String) - Critical level logging with Sentry
//     - error(dynamic, StackTrace?) - Error logging with Sentry
// ===============================================

import 'dart:isolate';

import 'package:flutter/foundation.dart'; // Import for kReleaseMode
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'app.dart'; // Import to access isSentryEnabled

final _logger = TalkerLogger(
  settings: TalkerLoggerSettings(
    enableColors: false,
    lineSymbol: '',
  ),
  formatter: CleanLogFormatter(),
  output: debugPrint,
);

final talker = Talker(
  settings: TalkerSettings(
    useConsoleLogs: false,
  ),
)..configure(
    observer: ConsoleLoggerObserver(_logger),
  );

/// Custom log formatter for Talker.
///
/// Format:
/// [LEVEL][isolate] HH:mm:ss.SSS | message
///
/// Example:
/// [INFO][main] 16:03:12.123 | Camera stream started
/// [ERROR][vision-worker] 16:03:15.456 | Frame processing failed
class CleanLogFormatter extends LoggerFormatter {
  @override
  String fmt(
    LogDetails details,
    TalkerLoggerSettings settings,
  ) {
    final now = DateTime.now();

    final level = details.level.toString().split('.').last.toUpperCase();

    final message = details.message?.toString() ?? '';

    final timeStr = '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}.'
        '${now.millisecond.toString().padLeft(3, '0')}';

    final isolateInfo = _getIsolateInfo();

    return '[$level] $timeStr | $message [$isolateInfo]';
  }

  String _getIsolateInfo() {
    try {
      final debugName = Isolate.current.debugName;

      if (debugName == null || debugName.isEmpty) {
        return 'isolate';
      }

      return debugName;
    } catch (_) {
      return 'unknown';
    }
  }
}

/// Opens the Talker console screen as a modal route for in-app log viewing.
void logShowConsole(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => TalkerScreen(
        talker: talker,
        appBarTitle: 'Console',
      ),
    ),
  );
}

/// Logs a debug message.
///
/// Debug messages are only written during debug builds.
///
/// Example:
///   logDebug('Camera stream starting');
void logDebug(String message) {
  if (kDebugMode) {
    talker.debug(message);
  }
}

/// Logs an informational message.
///
/// Also records the message as a Sentry breadcrumb when Sentry is enabled.
///
/// Info messages are intentionally NOT sent to Sentry as events.
void logInfo(String message) {
  talker.info(message);

  _addSentryBreadcrumb(
    message: message,
    level: SentryLevel.info,
  );
}

/// Logs a warning message.
///
/// Warnings are intentionally NOT sent to Sentry as events,
/// but are recorded as breadcrumbs for later error investigation.
void logWarning(String message) {
  talker.warning(message);

  _addSentryBreadcrumb(
    message: message,
    level: SentryLevel.warning,
  );
}

/// Logs a fatal/critical message.
///
/// A fatal message is sent to Sentry as a message event.
///
/// Use this only when the condition represents a serious application
/// failure, rather than a normal recoverable error.
void logFatal(
  String message, {
  bool sendToSentry = true,
}) {
  talker.critical(message);

  if (sendToSentry && isSentryEnabled) {
    try {
      Sentry.captureMessage(
        message,
        level: SentryLevel.fatal,
      );
    } catch (ex) {
      // Never allow logging/reporting to cause another application failure.
      debugPrint(
        'Sentry fatal message reporting failed: $ex',
      );
    }
  }
}

/// Logs an error/exception and optionally reports it to Sentry.
///
/// [exception] is the error or exception object.
///
/// [stackTrace] is the optional stack trace associated with the error.
///
/// [context] provides additional information about where/why the error
/// occurred. It is included in both the local log and Sentry.
///
/// [sendToSentry] controls whether the exception is sent to Sentry.
///
/// Example:
///   logError(
///     exception,
///     stackTrace: stackTrace,
///     context: 'CameraNotifier._startStream',
///   );
void logError(
  Object exception, {
  StackTrace? stackTrace,
  String? context,
  bool sendToSentry = true,
}) {
  printErrorToConsole(
    exception,
    stackTrace,
    context: context,
  );

  if (sendToSentry) {
    sendErrorToSentry(
      exception,
      stackTrace,
      context: context,
    );
  }
}

/// Prints an error and optional stack trace to the console using Talker.
void printErrorToConsole(
  Object exception,
  StackTrace? stackTrace, {
  String? context,
}) {
  final message = context == null || context.isEmpty ? 'Unexpected error' : context;

  talker.handle(
    exception,
    stackTrace,
    message,
  );
}

/// Sends an error/exception to Sentry if enabled.
///
/// [context] is added as a Sentry tag/breadcrumb so the error is easier
/// to identify in Sentry.
void sendErrorToSentry(
  Object exception,
  StackTrace? stackTrace, {
  String? context,
}) {
  if (!isSentryEnabled) {
    return;
  }

  try {
    if (context != null && context.isNotEmpty) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: context,
          category: 'error.context',
          level: SentryLevel.error,
        ),
      );
    }

    Sentry.captureException(
      exception,
      stackTrace: stackTrace,
    );
  } catch (ex) {
    // Never allow Sentry reporting to cause another application failure.
    debugPrint(
      'Sentry error reporting failed: $ex',
    );
  }
}

/// Adds a breadcrumb to the current Sentry scope.
///
/// Breadcrumbs are useful for reconstructing what the application was
/// doing immediately before an error occurred.
///
/// Info/warning logs are recorded as breadcrumbs rather than individual
/// Sentry events to avoid generating excessive Sentry events.
void _addSentryBreadcrumb({
  required String message,
  required SentryLevel level,
}) {
  if (!isSentryEnabled) {
    return;
  }

  try {
    Sentry.addBreadcrumb(
      Breadcrumb(
        message: message,
        category: 'app',
        level: level,
      ),
    );
  } catch (ex) {
    // Logging must never interfere with application execution.
    debugPrint(
      'Sentry breadcrumb failed: $ex',
    );
  }
}

/// Observer that logs Talker events to the console using a custom logger.
class ConsoleLoggerObserver extends TalkerObserver {
  final TalkerLogger logger;
  ConsoleLoggerObserver(this.logger);

  @override
  void onLog(TalkerData log) {
    _log(log);
  }

  @override
  void onError(TalkerError err) {
    _log(err);
  }

  @override
  void onException(TalkerException err) {
    _log(err);
  }

  void _log(TalkerData data) {
    var msg = data.message?.toString() ?? '';
    if (data is TalkerError) {
      msg += '\n${data.exception}';
      if (data.stackTrace != null) {
        msg += '\n${data.stackTrace}';
      }
    } else if (data is TalkerException) {
      msg += '\n${data.exception}';
      if (data.stackTrace != null) {
        msg += '\n${data.stackTrace}';
      }
    }
    logger.log(msg, level: data.logLevel);
  }
}

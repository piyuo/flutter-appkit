import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'l10n/l10n.dart';

final navigatorKey = GlobalKey<NavigatorState>();

/// Displays a Cupertino error dialog with details.
///
/// [e] is the error to display.
/// [stack] is the optional stack trace.
void showError(dynamic e, StackTrace? stack) {
  final context = navigatorKey.currentContext;
  if (context == null) {
    debugPrint('Navigator is not ready.');
    return;
  }

  showMessage(
    message: e.toString(),
    title: context.l.error_content,
  );
}

void showMessage({
  required String message,
  String? title,
  bool isDestructive = false,
}) {
  final context = navigatorKey.currentContext;
  if (context == null) {
    debugPrint('Navigator is not ready.');
    return;
  }

  showCupertinoDialog<void>(
    context: context,
    routeSettings: const RouteSettings(name: 'showMessage'),
    barrierDismissible: false,
    builder: (context) => CupertinoAlertDialog(
      title: title != null ? Text(title) : null,
      content: Text(message),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          isDestructiveAction: isDestructive,
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: Text(
            MaterialLocalizations.of(context).okButtonLabel,
          ),
        ),
      ],
    ),
  );
}

Future<bool> showConfirm({
  required String message,
  String? title,
  bool isDestructive = false,
}) async {
  final context = navigatorKey.currentContext;
  if (context == null) {
    debugPrint('Navigator is not ready.');
    return false;
  }

  return await showCupertinoDialog<bool>(
        context: context,
        routeSettings: const RouteSettings(name: 'showConfirm'),
        barrierDismissible: false,
        builder: (context) => CupertinoAlertDialog(
          title: title != null ? Text(title) : null,
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(false),
              child: Text(
                MaterialLocalizations.of(context).cancelButtonLabel,
              ),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              isDestructiveAction: isDestructive,
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(true),
              child: Text(
                MaterialLocalizations.of(context).okButtonLabel,
              ),
            ),
          ],
        ),
      ) ??
      false;
}

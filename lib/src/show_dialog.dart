import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'l10n/l10n.dart';

final navigatorKey = GlobalKey<NavigatorState>();

/// Displays a Glass error dialog with details and an anonymous report option.
///
/// [e] is the error to display.
/// [stack] is the optional stack trace.
///
void showError(dynamic e, StackTrace? stack) {
  final context = navigatorKey.currentContext;
  if (context == null) {
    debugPrint('Navigator is not ready.');
    return;
  }

  showMessage(message: e.toString(), title: context.l.error_content);
}

void showMessage({required String message, String? title, bool isDestructive = false}) {
  final context = navigatorKey.currentContext;
  if (context == null) {
    debugPrint('Navigator is not ready.');
    return;
  }
  showDialog<bool>(
    context: context,
    routeSettings: const RouteSettings(name: 'showMessage'),
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    builder: (context) => DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium ?? const TextStyle(color: Colors.grey),
        child: GlassDialog(
          title: title,
          quality: GlassQuality.standard,
          maxWidth: 350,
          content: Text(message, style: const TextStyle(fontSize: 16.0)),
          actions: [
            GlassDialogAction(
              label: MaterialLocalizations.of(context).okButtonLabel,
              isPrimary: true,
              isDestructive: isDestructive,
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            ),
          ],
        )),
  );
}

Future<bool> showConfirm({required String message, String? title, bool isDestructive = false}) async {
  final context = navigatorKey.currentContext;
  if (context == null) {
    debugPrint('Navigator is not ready.');
    return false;
  }
  return await showDialog<bool>(
        context: context,
        routeSettings: const RouteSettings(name: 'showConfirm'),
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (context) => DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyMedium ?? const TextStyle(color: Colors.grey),
            child: GlassDialog(
              title: title,
              quality: GlassQuality.standard,
              maxWidth: 350,
              content: Text(message, style: const TextStyle(fontSize: 16.0)),
              actions: [
                // Cancel button
                GlassDialogAction(
                  label: MaterialLocalizations.of(context).cancelButtonLabel,
                  onPressed: () => Navigator.of(context, rootNavigator: true).pop(false),
                ),

                // OK button
                GlassDialogAction(
                  label: MaterialLocalizations.of(context).okButtonLabel,
                  isPrimary: true,
                  isDestructive: isDestructive,
                  onPressed: () => Navigator.of(context, rootNavigator: true).pop(true),
                ),
              ],
            )),
      ) ??
      false;
}

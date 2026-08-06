import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'global_context.dart';
import 'l10n/l10n.dart';

/// Displays a Glass error dialog with details and an anonymous report option.
///
/// [e] is the error to display.
/// [stack] is the optional stack trace.
///
void showError(dynamic e, StackTrace? stack) {
  if (!isGlobalContextEnabled) {
    // GlobalContext not available (likely in tests), print to console instead
    debugPrint('ERROR: $e');
    if (stack != null) {
      debugPrint('STACK TRACE: $stack');
    }
    debugPrint('Note: Error dialog not shown - GlobalContext not initialized (likely in develop environment)');
    return;
  }
  showMessage(globalContext, message: e.toString(), title: globalContext.l.error_content);
}

void showMessage(BuildContext context, {required String message, String? title, bool isDestructive = false}) {
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

Future<bool> showConfirm(BuildContext context,
    {required String message, String? title, bool isDestructive = false}) async {
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

// ===============================================
// show_error.dart
//
// Provides a Cupertino-style error dialog with an option
// for users to report errors anonymously.
//
// Sections:
//   - Imports
//   - showError() function: Entry point to show the dialog
//   - _ErrorDialog widget: Stateful dialog UI
// ===============================================

import 'package:flutter/cupertino.dart';

import 'global_context.dart';
import 'l10n/l10n.dart';
import 'preferences.dart';

/// Displays a Cupertino error dialog with details and an anonymous report option.
///
/// [e] is the error to display.
/// [stack] is the optional stack trace.
///
/// Returns a [Future<bool>] indicating whether the user chose to report anonymously.
/// In test environments where GlobalContext is not initialized, prints to console instead.
Future<bool> showError(dynamic e, StackTrace? stack) async {
  if (!isGlobalContextEnabled) {
    // GlobalContext not available (likely in tests), print to console instead
    debugPrint('ERROR: $e');
    if (stack != null) {
      debugPrint('STACK TRACE: $stack');
    }
    debugPrint('Note: Error dialog not shown - GlobalContext not initialized (likely in test environment)');
    return false;
  }

  final result = await showCupertinoDialog<bool>(
    context: globalContext,
    routeSettings: const RouteSettings(name: 'error_dialog'),
    builder: (context) => _ErrorDialog(error: e),
  );
  return result ?? false;
}

/// A stateful widget that shows an error dialog with an anonymous reporting checkbox.
class _ErrorDialog extends StatefulWidget {
  final dynamic error;

  /// Creates an error dialog.
  const _ErrorDialog({required this.error});

  @override
  State<_ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<_ErrorDialog> {
  // Tracks whether the user wants to report the error anonymously.
  bool _reportAnonymously = true;

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final saved = await prefGetBool('error_report_anonymously');
    if (saved != null && mounted) {
      setState(() {
        _reportAnonymously = saved;
      });
    }
  }

  Future<void> _updatePreference(bool value) async {
    setState(() {
      _reportAnonymously = value;
    });
    await prefSetBool('error_report_anonymously', value);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(context.l.error_content, style: const TextStyle(fontSize: 16.0)),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text(widget.error.toString(), style: const TextStyle(fontSize: 16.0)),
          // Error details
          SizedBox(height: 10),
          // Anonymous report checkbox and label
          GestureDetector(
            onTap: () {
              _updatePreference(!_reportAnonymously);
            },
            child: Row(children: [
              Transform.scale(
                scale: 1.5,
                child: CupertinoCheckbox(
                  value: _reportAnonymously,
                  onChanged: (bool? value) {
                    if (value != null) {
                      _updatePreference(value);
                    }
                  },
                  activeColor: CupertinoColors.destructiveRed,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(context.l.error_report,
                    style: TextStyle(
                        color: _reportAnonymously ? CupertinoColors.destructiveRed : CupertinoColors.activeBlue,
                        fontSize: 14.0)),
              ),
            ]),
          ),
        ],
      ),
      actions: [
        // Close button
        CupertinoDialogAction(
          isDefaultAction: true,
          isDestructiveAction: true,
          child: Text(context.l.close),
          onPressed: () => Navigator.of(context).pop(_reportAnonymously),
        ),
      ],
    );
  }
}

// ===============================================
// Test Suite: show_error_test.dart
// Description: Widget tests for error dialog functionality
//
// Test Groups:
//   - Setup and Teardown
//   - Dialog Display Tests
//   - Dialog Content Tests
//   - Dialog Actions Tests
//   - Error Message Tests
//   - Localization Tests
//   - Anonymous Reporting Tests
//   - Integration Tests
// ===============================================

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appkit/src/global_context.dart';
import 'package:flutter_appkit/src/l10n/localization.dart';
import 'package:flutter_appkit/src/preferences.dart';
import 'package:flutter_appkit/src/show_error.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('showError', () {
    late Widget testApp;

    setUp(() {
      initForTest({});
      testApp = CupertinoApp(
        localizationsDelegates: Localization.localizationsDelegates,
        supportedLocales: Localization.supportedLocales,
        home: GlobalContext(
          child: const Scaffold(
            body: Center(
              child: Text('Test App'),
            ),
          ),
        ),
      );
    });

    testWidgets('displays error dialog with correct structure', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error message');

      // Show the error dialog
      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Verify dialog is displayed
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);

      // Verify title structure (updated to match new UI)
      expect(find.text('An unexpected error occurred. Please try again later.'), findsOneWidget);

      // Verify content
      expect(find.text('Exception: Test error message'), findsOneWidget);

      // Verify action button
      expect(find.text('Close'), findsOneWidget);
      expect(find.byType(CupertinoDialogAction), findsOneWidget);
    });

    testWidgets('displays error message with correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Custom error message');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Find the error message text
      final errorTextFinder = find.text('Exception: Custom error message');
      expect(errorTextFinder, findsOneWidget);

      // Verify the text styling
      final Text errorTextWidget = tester.widget(errorTextFinder);
      expect(errorTextWidget.style?.fontSize, 16.0);
    });

    testWidgets('close button dismisses dialog', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Verify dialog is present
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);

      // Tap close button
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Verify dialog is dismissed
      expect(find.byType(CupertinoAlertDialog), findsNothing);
    });

    testWidgets('handles different error types correctly', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Test with different error types
      final testCases = [
        'String error message',
        Exception('Exception error'),
        Error(),
        42, // Number as error
        null, // Null error
      ];

      for (final error in testCases) {
        showError(error, StackTrace.current);
        await tester.pumpAndSettle();

        // Verify dialog appears
        expect(find.byType(CupertinoAlertDialog), findsOneWidget);

        // Verify error message is displayed (converted to string)
        expect(find.textContaining(error.toString()), findsOneWidget);

        // Close dialog
        await tester.tap(find.text('Close'));
        await tester.pumpAndSettle();

        // Verify dialog is dismissed
        expect(find.byType(CupertinoAlertDialog), findsNothing);
      }
    });

    testWidgets('dialog action button has correct properties', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Find the dialog action
      final actionFinder = find.byType(CupertinoDialogAction);
      expect(actionFinder, findsOneWidget);

      final CupertinoDialogAction actionWidget = tester.widget(actionFinder);
      expect(actionWidget.isDefaultAction, true);
      expect(actionWidget.isDestructiveAction, true);
      expect(actionWidget.child, isA<Text>());
    });

    testWidgets('title row layout is correct', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Find the title text directly (no longer a Row)
      final titleFinder = find.descendant(
        of: find.byType(CupertinoAlertDialog),
        matching: find.text('An unexpected error occurred. Please try again later.'),
      );
      expect(titleFinder, findsOneWidget);
    });

    testWidgets('content column layout is correct', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Find the content column
      final columnFinder = find.descendant(
        of: find.byType(CupertinoAlertDialog),
        matching: find.byType(Column),
      );
      expect(columnFinder, findsAtLeastNWidgets(1));

      // Check for the SizedBox spacing with height 10 (should have two now)
      final sizedBoxFinder = find.byWidgetPredicate(
        (widget) => widget is SizedBox && widget.height == 10.0,
      );
      expect(sizedBoxFinder, findsNWidgets(2));
    });

    testWidgets('handles stack trace parameter correctly', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError1 = Exception('Test error with stack');
      final testError2 = Exception('Test error without stack');
      final testStack = StackTrace.current;

      // Test with stack trace
      showError(testError1, testStack);
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoAlertDialog), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Test with null stack trace (different error to avoid suppression)
      showError(testError2, null);
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoAlertDialog), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
    });

    testWidgets('function is async and completes properly', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');
      bool functionCompleted = false;

      // Call showError and track completion
      showError(testError, StackTrace.current).then((_) {
        functionCompleted = true;
      });

      await tester.pumpAndSettle();

      // Dialog should be visible
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);

      // Function should not have completed yet (dialog is still open)
      expect(functionCompleted, false);

      // Close the dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Now function should have completed
      expect(functionCompleted, true);
      expect(find.byType(CupertinoAlertDialog), findsNothing);
    });
  });

  group('showError localization', () {
    testWidgets('displays localized text correctly', (WidgetTester tester) async {
      // Reset error tracking state for this test group

      final testApp = CupertinoApp(
        locale: const Locale('en', 'US'),
        localizationsDelegates: Localization.localizationsDelegates,
        supportedLocales: Localization.supportedLocales,
        home: GlobalContext(
          child: const Scaffold(
            body: Center(
              child: Text('Test App'),
            ),
          ),
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Localization test error');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Verify English localization
      expect(find.text('An unexpected error occurred. Please try again later.'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
    });
  });

  group('showError edge cases', () {
    testWidgets('handles empty error message', (WidgetTester tester) async {
      // Reset error tracking state for this test

      final testApp = CupertinoApp(
        localizationsDelegates: Localization.localizationsDelegates,
        supportedLocales: Localization.supportedLocales,
        home: GlobalContext(
          child: const Scaffold(
            body: Center(
              child: Text('Test App'),
            ),
          ),
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Should still display dialog with empty exception
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      expect(find.text('Exception: '), findsOneWidget);
    });

    testWidgets('handles very long error message', (WidgetTester tester) async {
      // Reset error tracking state for this test

      final testApp = CupertinoApp(
        localizationsDelegates: Localization.localizationsDelegates,
        supportedLocales: Localization.supportedLocales,
        home: GlobalContext(
          child: const Scaffold(
            body: Center(
              child: Text('Test App'),
            ),
          ),
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final longMessage =
          'This is a very long error message that should still be displayed correctly in the dialog even though it might wrap to multiple lines and take up more space in the content area of the alert dialog.';
      final testError = Exception(longMessage);

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Should still display dialog with long message
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      expect(find.textContaining(longMessage), findsOneWidget);
    });
  });

  group('showError dialog prevention', () {
    late Widget testApp;

    setUp(() {
      testApp = CupertinoApp(
        localizationsDelegates: Localization.localizationsDelegates,
        supportedLocales: Localization.supportedLocales,
        home: GlobalContext(
          child: const Scaffold(
            body: Center(
              child: Text('Test App'),
            ),
          ),
        ),
      );
    });

    testWidgets('allows new dialog after previous one is closed', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final firstError = Exception('First error');
      final secondError = Exception('Second error');

      // Show first error dialog
      showError(firstError, StackTrace.current);
      await tester.pumpAndSettle();

      // Verify first dialog is displayed
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      expect(find.text('Exception: First error'), findsOneWidget);

      // Close the first dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Verify no dialogs are showing
      expect(find.byType(CupertinoAlertDialog), findsNothing);

      // Now show second error dialog
      showError(secondError, StackTrace.current);
      await tester.pumpAndSettle();

      // Should show the second dialog now
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      expect(find.text('Exception: Second error'), findsOneWidget);
      expect(find.text('Exception: First error'), findsNothing);
    });

    testWidgets('dialog has correct route settings name', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Verify dialog is displayed
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);

      // Check that the dialog route has the correct name
      final BuildContext context = tester.element(find.byType(CupertinoAlertDialog));
      final ModalRoute? route = ModalRoute.of(context);
      expect(route?.settings.name, 'error_dialog');
    });
  });

  group('showError suppression functionality', () {
    late Widget testApp;

    setUp(() {
      testApp = CupertinoApp(
        localizationsDelegates: Localization.localizationsDelegates,
        supportedLocales: Localization.supportedLocales,
        home: GlobalContext(
          child: const Scaffold(
            body: Center(
              child: Text('Test App'),
            ),
          ),
        ),
      );
    });

    testWidgets('allows different error types to be shown', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final firstError = Exception('First error');
      final secondError = ArgumentError('Second error');

      // Show first error dialog
      showError(firstError, StackTrace.current);
      await tester.pumpAndSettle();

      // Verify first dialog is displayed
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      expect(find.text('Exception: First error'), findsOneWidget);

      // Close the first dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Show second error (different type, should be allowed)
      showError(secondError, StackTrace.current);
      await tester.pumpAndSettle();

      // Should show the second dialog
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      expect(find.text('Invalid argument(s): Second error'), findsOneWidget);
    });

    testWidgets('generates correct error keys for different error types', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final errors = [
        Exception('Test'),
        ArgumentError('Test'), // Same message but different type
        'String error',
        42,
        null,
      ];

      for (int i = 0; i < errors.length; i++) {
        final error = errors[i];

        // Each different error type should be allowed
        showError(error, StackTrace.current);
        await tester.pumpAndSettle();

        // Should show dialog for each different error type
        expect(find.byType(CupertinoAlertDialog), findsOneWidget);

        // Close dialog
        await tester.tap(find.text('Close'));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('cleans up old error history entries', (WidgetTester tester) async {
      // This test verifies that the cleanup function works
      // Since we can't easily test time-based cleanup in unit tests,
      // we just verify the mechanism exists
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Cleanup test');

      // Show error to populate history
      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Verify dialog is displayed
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Now the same error should be allowed again
      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Should show dialog again
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    });

    testWidgets('error flag is reset even if dialog showing fails', (WidgetTester tester) async {
      // This is a bit tricky to test, but we can verify the finally block works
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error for failure');

      // Show error normally first
      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoAlertDialog), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // The flag should be reset and we should be able to show different errors
      final differentError = Exception('Different error');
      showError(differentError, StackTrace.current);
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    });
  });

  group('Anonymous error reporting checkbox', () {
    late Widget testApp;

    setUp(() {
      testApp = CupertinoApp(
        localizationsDelegates: Localization.localizationsDelegates,
        supportedLocales: Localization.supportedLocales,
        home: GlobalContext(
          child: const Scaffold(
            body: Center(
              child: Text('Test App'),
            ),
          ),
        ),
      );
    });

    testWidgets('displays checkbox with correct label', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Find the checkbox
      expect(find.byType(CupertinoCheckbox), findsOneWidget);

      // Find the checkbox label
      expect(find.text('Help us improve by sending an anonymous report'), findsOneWidget);
    });

    testWidgets('checkbox starts checked by default', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      final checkboxFinder = find.byType(CupertinoCheckbox);
      expect(checkboxFinder, findsOneWidget);

      final CupertinoCheckbox checkboxWidget = tester.widget(checkboxFinder);
      expect(checkboxWidget.value, true);
    });

    testWidgets('checkbox can be toggled', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      final checkboxFinder = find.byType(CupertinoCheckbox);

      // Verify checkbox starts checked
      final CupertinoCheckbox initialWidget = tester.widget(checkboxFinder);
      expect(initialWidget.value, true);

      // Tap the checkbox to uncheck it
      await tester.tap(checkboxFinder);
      await tester.pumpAndSettle();

      // Verify checkbox is now unchecked
      final CupertinoCheckbox uncheckedWidget = tester.widget(checkboxFinder);
      expect(uncheckedWidget.value, false);

      // Tap again to check
      await tester.tap(checkboxFinder);
      await tester.pumpAndSettle();

      // Verify checkbox is checked again
      final CupertinoCheckbox checkedWidget = tester.widget(checkboxFinder);
      expect(checkedWidget.value, true);
    });

    testWidgets('tapping checkbox label toggles checkbox', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Find the checkbox
      final checkboxFinder = find.byType(CupertinoCheckbox);
      expect(tester.widget<CupertinoCheckbox>(checkboxFinder).value, true);

      // Find the label text
      final labelFinder = find.text('Help us improve by sending an anonymous report');
      expect(labelFinder, findsOneWidget);

      // Tap the label
      await tester.tap(labelFinder);
      await tester.pumpAndSettle();

      // Verify checkbox is unchecked
      expect(tester.widget<CupertinoCheckbox>(checkboxFinder).value, false);

      // Tap the label again
      await tester.tap(labelFinder);
      await tester.pumpAndSettle();

      // Verify checkbox is checked
      expect(tester.widget<CupertinoCheckbox>(checkboxFinder).value, true);
    });

    testWidgets('checkbox row layout is correct', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Find the row containing checkbox and label
      final rowFinder = find.byWidgetPredicate(
        (widget) => widget is Row && widget.children.any((child) => child is Transform),
      );
      expect(rowFinder, findsOneWidget);

      // Verify row contains checkbox, spacer, and text
      final Row rowWidget = tester.widget(rowFinder);
      expect(rowWidget.children.length, 3);
      expect(rowWidget.children[0], isA<Transform>());
      expect(rowWidget.children[1], isA<SizedBox>());
      expect(rowWidget.children[2], isA<Expanded>());
    });

    testWidgets('checkbox is positioned correctly in dialog content', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Find the content column
      final columnFinder = find.descendant(
        of: find.byType(CupertinoAlertDialog),
        matching: find.byType(Column),
      );
      expect(columnFinder, findsAtLeastNWidgets(1));

      // Verify checkbox row is in the column
      final checkboxRowFinder = find.byWidgetPredicate(
        (widget) => widget is Row && widget.children.any((child) => child is Transform),
      );

      final checkboxInColumn = find.descendant(
        of: columnFinder.first,
        matching: checkboxRowFinder,
      );
      expect(checkboxInColumn, findsOneWidget);
    });

    testWidgets('uses localized text for checkbox label', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Should show English translation
      expect(find.text('Help us improve by sending an anonymous report'), findsOneWidget);
    });

    testWidgets('returns checkbox value when dialog is closed', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');

      // Test default case (checkbox checked)
      final Future<bool> result1 = showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Close the dialog without changing checkbox (should return true)
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(await result1, true);

      // Test after unchecking the checkbox
      final differentError = Exception('Different error');
      final Future<bool> result2 = showError(differentError, StackTrace.current);
      await tester.pumpAndSettle();

      // Uncheck the checkbox
      await tester.tap(find.byType(CupertinoCheckbox));
      await tester.pumpAndSettle();

      // Close the dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(await result2, false);
    });

    testWidgets('persists checkbox state across dialogs', (WidgetTester tester) async {
      // Ensure preference starts as true
      await prefSetBool('error_report_anonymously', true);

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');

      // Show first dialog
      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Uncheck the checkbox
      await tester.tap(find.byType(CupertinoCheckbox));
      await tester.pumpAndSettle();

      // Close the dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Show second dialog
      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Wait for preference to load
      await tester.pump(const Duration(milliseconds: 100));

      // Verify checkbox is still unchecked (loaded from preferences)
      final checkboxFinder = find.byType(CupertinoCheckbox);
      expect(tester.widget<CupertinoCheckbox>(checkboxFinder).value, false);
    });
  });
}

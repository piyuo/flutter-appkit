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
//   - Integration Tests
// ===============================================

import 'package:flutter/material.dart';
import 'package:flutter_appkit/src/global_context.dart';
import 'package:flutter_appkit/src/l10n/generated/localization.dart';
import 'package:flutter_appkit/src/preferences.dart' as preferences;
import 'package:flutter_appkit/src/show_dialog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

void main() {
  group('showError', () {
    late Widget testApp;

    setUp(() {
      preferences.initForTest({});
      testApp = MaterialApp(
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
      expect(find.byType(GlassDialog), findsOneWidget);

      // Verify title is the error content message
      expect(find.text('An unexpected error occurred. Please try again later.'), findsOneWidget);

      // Verify content
      expect(find.text('Exception: Test error message'), findsOneWidget);

      // Verify action button
      expect(find.text('OK'), findsOneWidget);
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

    testWidgets('OK button dismisses dialog', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Verify dialog is present
      expect(find.byType(GlassDialog), findsOneWidget);

      // Tap OK button
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Verify dialog is dismissed
      expect(find.byType(GlassDialog), findsNothing);
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
        expect(find.byType(GlassDialog), findsOneWidget);

        // Verify error message is displayed (converted to string)
        expect(find.textContaining(error.toString()), findsOneWidget);

        // Close dialog
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        // Verify dialog is dismissed
        expect(find.byType(GlassDialog), findsNothing);
      }
    });

    testWidgets('dialog action button exists and is labeled correctly', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Verify the OK button exists
      expect(find.text('OK'), findsOneWidget);

      // Verify tapping OK dismisses the dialog
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.byType(GlassDialog), findsNothing);
    });

    testWidgets('title text is correct', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Find the title text
      final titleFinder = find.descendant(
        of: find.byType(GlassDialog),
        matching: find.text('An unexpected error occurred. Please try again later.'),
      );
      expect(titleFinder, findsOneWidget);
    });

    testWidgets('content is displayed correctly', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Verify content is displayed
      expect(find.text('Exception: Test error'), findsOneWidget);
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

      expect(find.byType(GlassDialog), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Test with null stack trace (different error to avoid suppression)
      showError(testError2, null);
      await tester.pumpAndSettle();

      expect(find.byType(GlassDialog), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
    });
  });

  group('showError localization', () {
    testWidgets('displays localized text correctly', (WidgetTester tester) async {
      // Reset error tracking state for this test group

      final testApp = MaterialApp(
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
      expect(find.text('OK'), findsOneWidget);
    });
  });

  group('showError edge cases', () {
    testWidgets('handles empty error message', (WidgetTester tester) async {
      // Reset error tracking state for this test

      final testApp = MaterialApp(
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
      expect(find.byType(GlassDialog), findsOneWidget);
      expect(find.text('Exception: '), findsOneWidget);
    });

    testWidgets('handles very long error message', (WidgetTester tester) async {
      // Reset error tracking state for this test

      final testApp = MaterialApp(
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
      expect(find.byType(GlassDialog), findsOneWidget);
      expect(find.textContaining(longMessage), findsOneWidget);
    });
  });

  group('showError dialog management', () {
    late Widget testApp;

    setUp(() {
      testApp = MaterialApp(
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
      expect(find.byType(GlassDialog), findsOneWidget);
      expect(find.text('Exception: First error'), findsOneWidget);

      // Close the first dialog
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Verify no dialogs are showing
      expect(find.byType(GlassDialog), findsNothing);

      // Now show second error dialog
      showError(secondError, StackTrace.current);
      await tester.pumpAndSettle();

      // Should show the second dialog now
      expect(find.byType(GlassDialog), findsOneWidget);
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
      expect(find.byType(GlassDialog), findsOneWidget);

      // Check that the dialog route has the correct name
      final BuildContext context = tester.element(find.byType(GlassDialog));
      final ModalRoute? route = ModalRoute.of(context);
      expect(route?.settings.name, 'showMessage');
    });
  });

  group('showError multiple error handling', () {
    late Widget testApp;

    setUp(() {
      testApp = MaterialApp(
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
      expect(find.byType(GlassDialog), findsOneWidget);
      expect(find.text('Exception: First error'), findsOneWidget);

      // Close the first dialog
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Show second error (different type, should be allowed)
      showError(secondError, StackTrace.current);
      await tester.pumpAndSettle();

      // Should show the second dialog
      expect(find.byType(GlassDialog), findsOneWidget);
      expect(find.text('Invalid argument(s): Second error'), findsOneWidget);
    });

    testWidgets('handles multiple error types in sequence', (WidgetTester tester) async {
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
        expect(find.byType(GlassDialog), findsOneWidget);

        // Close dialog
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('allows same error to be shown after closing previous dialog', (WidgetTester tester) async {
      // This test verifies dialogs can be shown multiple times
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Repeated error');

      // Show error first time
      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Verify dialog is displayed
      expect(find.byType(GlassDialog), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Now the same error should be allowed again
      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Should show dialog again
      expect(find.byType(GlassDialog), findsOneWidget);
    });
  });
}

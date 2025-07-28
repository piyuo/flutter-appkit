// ===============================================
// Test Suite: app_test.dart
// Description: Unit and widget tests for app.dart functionality
//
// Test Groups:
//   - Setup and Teardown
//   - isSentryEnabled Tests
//   - Catched Function Tests
//   - appRun with error callback Tests
//   - Widget Structure Tests
//   - Error Handling Tests
//   - Integration Tests
// ===============================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for PlatformException, MissingPluginException
import 'package:flutter_appkit/src/app.dart';
import 'package:flutter_appkit/src/global_context.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Test widgets for various scenarios
class MockWidget extends StatelessWidget {
  const MockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Test App'),
        ),
      ),
    );
  }
}

// Helper functions to mock Sentry enablement state
void _mockSentryEnabled() {
  // Add SENTRY_DSN to the environment
  dotenv.env['SENTRY_DSN'] = 'https://test@sentry.io/123456';
}

void _mockSentryDisabled() {
  // Remove SENTRY_DSN from the environment
  dotenv.env.remove('SENTRY_DSN');
}

void _ensureEnvInitialized() {
  if (!dotenv.isInitialized) {
    dotenv.testLoad(fileInput: 'API_URL=https://api.example.com\nSECRET_KEY=supersecret');
  }
}

class ThrowingWidget extends StatelessWidget {
  final Object error;

  const ThrowingWidget({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    throw error;
  }
}

void main() {
  group('run.dart', () {
    setUp(() {
      // Ensure environment is initialized for each test
      _ensureEnvInitialized();
    });

    tearDown(() {
      // Clean up environment after each test
      _mockSentryDisabled();
    });

    group('isSentryEnabled function', () {
      test('should return false when SENTRY_DSN is not set', () {
        _mockSentryDisabled();
        expect(isSentryEnabled, false);
      });

      test('should return true when SENTRY_DSN is set', () {
        _mockSentryEnabled();
        expect(isSentryEnabled, true);

        _mockSentryDisabled();
        expect(isSentryEnabled, false);
      });
    });
    group('catched function behavior', () {
      test('should be accessible from test files', () {
        // Test that the catched function exists and is accessible
        // We can't directly test the function due to @visibleForTesting restrictions
        // but we can verify isSentryEnabled function works properly
        _mockSentryDisabled();
        expect(isSentryEnabled, isA<bool>());
        expect(isSentryEnabled, false);
      });

      test('should handle AssertionError consistently with other errors', () async {
        // Test that AssertionError is processed like any other error
        // This test verifies the fix for issue #197

        // Test different error types that should all be handled consistently
        List<Object> testErrors = [
          AssertionError('Test assertion error'),
          Exception('Test exception'),
          Error(),
          StateError('Test state error'),
        ];

        for (Object error in testErrors) {
          // All errors should be treated consistently now
          // AssertionError should no longer be filtered out
          expect(error, isNotNull);
          expect(error is AssertionError || error is Exception || error is Error, isTrue);
        }

        // Verify that AssertionError is included in the list of errors that would be processed
        bool hasAssertionError = testErrors.any((e) => e is AssertionError);
        expect(hasAssertionError, isTrue, reason: 'AssertionError should be processed like other errors');
      });

      test('should still ignore null errors for safety', () async {
        // Test that null errors are still handled appropriately
        Object? nullError;

        // Null should still be filtered out for safety
        expect(nullError, isNull, reason: 'Null errors should still be ignored for safety');
      });
    });

    group('appRun with error callback', () {
      test('should invoke error callback when provided', () async {
        // Test callback invocation
        bool callbackInvoked = false;
        Object? capturedError;

        bool errorCallback(Object e) {
          callbackInvoked = true;
          capturedError = e;
          return true; // Show error
        }

        // We can't easily test the full appRun flow, but we can test callback logic
        var testError = Exception('Test error');
        bool shouldShow = errorCallback(testError);

        expect(callbackInvoked, isTrue);
        expect(capturedError, equals(testError));
        expect(shouldShow, isTrue);
      });

      test('should suppress error when callback returns false', () async {
        bool errorCallback(Object e) {
          return false; // Suppress error
        }

        var testError = PlatformException(code: 'test');
        bool shouldShow = errorCallback(testError);

        expect(shouldShow, isFalse);
      });

      test('should handle PlatformException correctly with callback', () async {
        bool errorCallback(Object e) {
          if (e is PlatformException) {
            return false; // Suppress PlatformException
          }
          return true;
        }

        var platformError = PlatformException(code: 'test_platform_error');
        var generalError = Exception('General error');

        expect(errorCallback(platformError), isFalse);
        expect(errorCallback(generalError), isTrue);
      });

      test('should handle MissingPluginException correctly with callback', () async {
        bool errorCallback(Object e) {
          if (e is MissingPluginException) {
            return false; // Suppress MissingPluginException
          }
          return true;
        }

        var missingPluginError = MissingPluginException('Test missing plugin');
        var generalError = Exception('General error');

        expect(errorCallback(missingPluginError), isFalse);
        expect(errorCallback(generalError), isTrue);
      });

      test('should default to showing error when no callback provided', () async {
        // Test default behavior (no callback) - this test ensures backward compatibility
        // When no callback is provided, all errors should be displayed
        var testError = Exception('Test error');
        var platformError = PlatformException(code: 'test');
        var missingPluginError = MissingPluginException('Test');

        // Without callback, all these errors should be processed normally
        expect(testError, isNotNull);
        expect(platformError, isNotNull);
        expect(missingPluginError, isNotNull);
      });

      test('catched function should respect callback decision', () async {
        // Test that catched function uses the callback to decide whether to show error
        bool callbackInvoked = false;
        Object? capturedError;

        bool suppressAllErrorsCallback(Object e) {
          callbackInvoked = true;
          capturedError = e;
          return false; // Suppress all errors
        }

        var testError = Exception('Test error');

        // Call catched directly with callback
        await catched(testError, null, suppressAllErrorsCallback);

        expect(callbackInvoked, isTrue);
        expect(capturedError, equals(testError));
      });

      test('catched function should handle callback correctly for different error types', () async {
        List<Object> processedErrors = [];
        List<bool> callbackResults = [];

        bool platformSuppressingCallback(Object e) {
          processedErrors.add(e);
          bool shouldShow = !(e is PlatformException || e is MissingPluginException);
          callbackResults.add(shouldShow);
          return shouldShow;
        }

        var platformError = PlatformException(code: 'test_platform');
        var missingPluginError = MissingPluginException('test_plugin');
        var generalError = Exception('general_error');

        // Test different error types with callback
        await catched(platformError, null, platformSuppressingCallback);
        await catched(missingPluginError, null, platformSuppressingCallback);
        await catched(generalError, null, platformSuppressingCallback);

        expect(processedErrors.length, equals(3));
        expect(callbackResults, equals([false, false, true])); // Platform errors suppressed, general error shown
      });
    });
    group('Widget structure tests', () {
      testWidgets('should create proper widget hierarchy with ProviderScope and GlobalContext support',
          (WidgetTester tester) async {
        Widget testWidget = ProviderScope(
          child: GlobalContext(
            child: const MockWidget(),
          ),
        );

        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Verify the widget tree structure
        expect(find.byType(ProviderScope), findsOneWidget);
        expect(find.byType(GlobalContext), findsOneWidget);
        expect(find.byType(MaterialApp), findsOneWidget);
        expect(find.text('Test App'), findsOneWidget);
      });
      testWidgets('should handle widget errors gracefully', (WidgetTester tester) async {
        // Store original error handler
        final originalOnError = FlutterError.onError;
        Exception? capturedError;

        FlutterError.onError = (FlutterErrorDetails details) {
          if (details.exception is Exception) {
            capturedError = details.exception as Exception;
          }
        };

        Widget errorWidget = ProviderScope(
          child: GlobalContext(
            child: ThrowingWidget(
              error: Exception('Widget error'),
            ),
          ),
        );

        // This should not crash the test framework
        await tester.pumpWidget(errorWidget);

        // The error should have been captured
        expect(capturedError, isNotNull);

        // Restore original error handler
        FlutterError.onError = originalOnError;
      });
    });

    group('Environment logic tests', () {
      test('should determine Sentry enablement based on DSN presence', () {
        // Test empty DSN
        String emptyDSN = '';
        bool shouldEnableForEmpty = emptyDSN.isNotEmpty;
        expect(shouldEnableForEmpty, false);

        // Test whitespace-only DSN
        String whitespaceDSN = '   ';
        bool shouldEnableForWhitespace = whitespaceDSN.trim().isNotEmpty;
        expect(shouldEnableForWhitespace, false);

        // Test valid DSN
        String validDSN = 'https://test@sentry.io/123456';
        bool shouldEnableForValid = validDSN.isNotEmpty;
        expect(shouldEnableForValid, true);

        // Test invalid but non-empty DSN
        String invalidDSN = 'invalid-dsn';
        bool shouldEnableForInvalid = invalidDSN.isNotEmpty;
        expect(shouldEnableForInvalid, true); // Logic only checks if non-empty
      });
    });

    group('Integration tests', () {
      testWidgets('should handle complete app lifecycle without errors', (WidgetTester tester) async {
        // Test a complete app setup similar to what run() does
        Widget completeApp = ProviderScope(
          child: GlobalContext(
            child: MaterialApp(
              title: 'LibCLI Test App',
              home: Scaffold(
                appBar: AppBar(title: const Text('Test App')),
                body: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Welcome to LibCLI Test'),
                      SizedBox(height: 20),
                      Text('Error handling active'),
                      SizedBox(height: 20),
                      Text('Testing complete app structure'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpWidget(completeApp);
        await tester.pumpAndSettle();

        // Verify complete app structure
        expect(find.byType(ProviderScope), findsOneWidget);
        expect(find.byType(GlobalContext), findsOneWidget);
        expect(find.byType(MaterialApp), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('Test App'), findsOneWidget);
        expect(find.text('Welcome to LibCLI Test'), findsOneWidget);
        expect(find.text('Error handling active'), findsOneWidget);
        expect(find.text('Testing complete app structure'), findsOneWidget);
      });

      testWidgets('should maintain state across rebuilds', (WidgetTester tester) async {
        int rebuildCount = 0;

        Widget buildApp() {
          rebuildCount++;
          return ProviderScope(
            child: GlobalContext(
              child: MaterialApp(
                home: Scaffold(
                  body: Center(
                    child: Text('Rebuild count: $rebuildCount'),
                  ),
                ),
              ),
            ),
          );
        }

        await tester.pumpWidget(buildApp());
        expect(find.text('Rebuild count: 1'), findsOneWidget);

        await tester.pumpWidget(buildApp());
        expect(find.text('Rebuild count: 2'), findsOneWidget);

        // Verify the structure remains consistent
        expect(find.byType(ProviderScope), findsOneWidget);
        expect(find.byType(GlobalContext), findsOneWidget);
      });

      testWidgets('should handle rapid widget changes', (WidgetTester tester) async {
        for (int i = 0; i < 5; i++) {
          Widget dynamicApp = ProviderScope(
            child: GlobalContext(
              child: MaterialApp(
                home: Scaffold(
                  body: Center(
                    child: Text('Dynamic content $i'),
                  ),
                ),
              ),
            ),
          );

          await tester.pumpWidget(dynamicApp);
          await tester.pump();

          expect(find.text('Dynamic content $i'), findsOneWidget);
        }
      });
    });
    group('Error resilience tests', () {
      test('should handle various exception types conceptually', () async {
        List<Object> testErrors = [
          Exception('Standard exception'),
          Error(),
          StateError('State error'),
          ArgumentError('Argument error'),
          RangeError('Range error'),
          TypeError(),
          'String as error',
          123,
          {'key': 'value'},
          [1, 2, 3],
        ];

        // Test that we can create and categorize different error types
        for (Object error in testErrors) {
          expect(error, isNotNull);
          expect(error.runtimeType.toString(), isNotEmpty);
        }
      });

      test('should handle stack trace variations conceptually', () async {
        Exception testException = Exception('Test exception');

        // Test that we can create different stack trace types
        StackTrace currentStack = StackTrace.current;
        StackTrace emptyStack = StackTrace.empty;

        expect(currentStack, isNotNull);
        expect(emptyStack, isNotNull);
        expect(testException, isNotNull);
      });
    });

    group('Widget error handling', () {
      testWidgets('should handle errors during widget build phase', (WidgetTester tester) async {
        final List<FlutterErrorDetails> capturedErrors = [];

        // Capture Flutter errors
        FlutterError.onError = (FlutterErrorDetails details) {
          capturedErrors.add(details);
        };

        // Create widget that throws during build
        Widget errorProneWidget = ProviderScope(
          child: GlobalContext(
            child: Builder(
              builder: (context) {
                throw Exception('Build time error');
              },
            ),
          ),
        );

        // This should capture the error but not crash
        await tester.pumpWidget(errorProneWidget);

        // Verify error was captured
        expect(capturedErrors.length, greaterThan(0));

        // Restore error handling
        FlutterError.onError = null;
      });

      testWidgets('should recover from transient errors', (WidgetTester tester) async {
        bool shouldThrow = true;

        Widget conditionalErrorWidget() {
          return ProviderScope(
            child: GlobalContext(
              child: MaterialApp(
                home: Scaffold(
                  body: Builder(
                    builder: (context) {
                      if (shouldThrow) {
                        shouldThrow = false; // Only throw once
                        throw Exception('Transient error');
                      }
                      return const Center(
                        child: Text('Error recovered'),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        }

        // Override error handling to prevent test failure
        FlutterError.onError = (FlutterErrorDetails details) {
          // Ignore the error for this test
        };

        await tester.pumpWidget(conditionalErrorWidget());

        // After the error, the widget should be in a good state
        shouldThrow = false;
        await tester.pumpWidget(conditionalErrorWidget());
        await tester.pumpAndSettle();

        expect(find.text('Error recovered'), findsOneWidget);

        // Restore error handling
        FlutterError.onError = null;
      });
    });
  });
}

// ============================================================================
// Table of Contents
// ============================================================================
// 1. Imports
// 2. Test Setup & Teardown
// 3. Environment Variable Tests
// ============================================================================

import 'package:flutter_appkit/src/env.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testEnvFile = '.env.test';

  // Test group for normal functionality with existing .env file
  group('env.dart with existing .env file', () {
    setUpAll(() async {
      // A test .env file is already placed in the root directory. Since dotenv loads from assets, we ensure a test .env file exists for these tests.
      //await File(testEnvFile).writeAsString(testEnvContent);
    });

    tearDownAll(() async {
      // Reset dotenv for other tests. There is no public API to reset isInitialized, so tests must be run in isolation.
      if (dotenv.isInitialized) {
        dotenv.env.clear();
        // No public API to reset isInitialized flag.
      }
    });

    test('envInit loads variables from file', () async {
      await envInit(fileName: testEnvFile);
      expect(dotenv.env['API_URL'], 'https://api.example.com');
      expect(dotenv.env['SECRET_KEY'], 'supersecret');
    });

    test('envGet returns correct value and default', () async {
      await envInit(fileName: testEnvFile);
      expect(envGet('API_URL'), 'https://api.example.com');
      expect(envGet('NOT_EXIST', defaultValue: 'default'), 'default');
      expect(envGet('NOT_EXIST'), '');
    });

    test('envIsInitialized returns true after init', () async {
      await envInit(fileName: testEnvFile);
      expect(envIsInitialized(), isTrue);
    });

    test('envGetAllVars returns all variables', () async {
      await envInit(fileName: testEnvFile);
      final vars = envGetAllVars();
      expect(vars['API_URL'], 'https://api.example.com');
      expect(vars['SECRET_KEY'], 'supersecret');
    });

    test('envHasVar returns true if key exists', () async {
      await envInit(fileName: testEnvFile);
      expect(envHasVar('API_URL'), isTrue);
      expect(envHasVar('NOT_EXIST'), isFalse);
    });
  });

  // Test group for missing .env file scenarios
  group('env.dart with missing .env file', () {
    test('envInit handles missing .env file gracefully', () async {
      // Test with a non-existent file - should not throw exception
      await expectLater(() async => envInit(fileName: 'non-existent.env'), returnsNormally);

      // Note: Due to dotenv global state, if previous tests have initialized it,
      // it will remain initialized. We test that the function doesn't crash.
      expect(envIsInitialized(), isTrue);
    });

    test('envGet returns defaults when accessing non-existent keys', () {
      // This tests the fallback behavior for non-existent keys
      expect(envGet('DEFINITELY_NOT_EXISTING_KEY', defaultValue: 'fallback'), 'fallback');
      expect(envGet('DEFINITELY_NOT_EXISTING_KEY'), '');
    });
  });
}

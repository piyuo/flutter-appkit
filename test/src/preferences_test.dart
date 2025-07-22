// =============================================================
// Test Suite: preferences_test.dart
// Description: Unit tests for Shared Preferences utility functions
//
// Test Groups:
//   - Setup and Teardown
//   - Key Existence and Removal
//   - Primitive Types (bool, int, double, string)
//   - Expiration Logic
//   - DateTime
//   - List and Map
// =============================================================

import 'package:flutter_appkit/src/preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Initializes mock preferences for each test run.
  // ignore: invalid_use_of_visible_for_testing_member
  initForTest({});

  // Use a counter to generate unique keys for each test to prevent race conditions
  int testCounter = 0;
  String getUniqueKey() => 'test_key_${testCounter++}';

  setUp(() async {});

  group('[preferences] Key Existence and Removal', () {
    test('clear() removes all keys', () async {
      final key = getUniqueKey();
      await prefSetBool(key, true);
      expect(await prefContainsKey(key), true);
      await prefClear();
      expect(await prefContainsKey(key), false);
    });

    test('containsKey() reflects key presence', () async {
      final key = getUniqueKey();
      expect(await prefContainsKey(key), false);
      await prefSetBool(key, true);
      expect(await prefContainsKey(key), true);
      await prefRemoveKey(key);
      expect(await prefContainsKey(key), false);
    });

    test('remove() deletes a key', () async {
      final key = getUniqueKey();
      await prefSetBool(key, true);
      expect(await prefGetBool(key), true);
      await prefRemoveKey(key);
      expect(await prefGetBool(key), null);
    });
  });

  group('[preferences] Primitive Types', () {
    test('get/set bool', () async {
      final key = getUniqueKey();
      await prefSetBool(key, true);
      expect(await prefGetBool(key), true);
      await prefSetBool(key, false);
      expect(await prefGetBool(key), false);
      await prefRemoveKey(key);
      expect(await prefGetBool(key), null);
      await prefSetBool(key, false);
      await prefSetBool(key, null);
      expect(await prefGetBool(key), null);
    });

    test('get/set int', () async {
      final key = getUniqueKey();
      await prefSetInt(key, 1);
      expect(await prefGetInt(key), 1);
      await prefRemoveKey(key);
      expect(await prefGetInt(key), null);
      await prefSetInt(key, 1);
      await prefSetInt(key, null);
      expect(await prefGetInt(key), null);
    });

    test('get/set double', () async {
      final key = getUniqueKey();
      await prefSetDouble(key, 1.1);
      expect(await prefGetDouble(key), 1.1);
      await prefRemoveKey(key);
      expect(await prefGetDouble(key), null);
      await prefSetDouble(key, 1.1);
      await prefSetDouble(key, null);
      expect(await prefGetDouble(key), null);
    });

    test('get/set string', () async {
      final key = getUniqueKey();
      await prefSetString(key, 'a');
      expect(await prefGetString(key), 'a');
      await prefRemoveKey(key);
      expect(await prefGetString(key), null);
      await prefSetString(key, 'a');
      await prefSetString(key, null);
      expect(await prefGetString(key), null);
    });
  });

  group('[preferences] Expiration Logic', () {
    test('get/set string with expiration', () async {
      final key = getUniqueKey();
      var now = DateTime.now();
      // Use 2 seconds for more reliable timing in test environments
      var exp =
          DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second).add(const Duration(seconds: 2));

      await prefSetStringWithExp(key, 'a', exp);
      expect(await prefGetDateTime('$key$expirationExt'), exp);
      expect(await prefGetStringWithExp(key), 'a');
      expect(await prefContainsKey(key), true);
      expect(await prefContainsKey('$key$expirationExt'), true);

      // Wait for expiration with some buffer time
      await Future.delayed(const Duration(seconds: 3));

      expect(await prefGetStringWithExp(key), null);
      expect(await prefContainsKey(key), false);
      expect(await prefContainsKey('$key$expirationExt'), false);
    });
  });

  group('[preferences] DateTime', () {
    test('get/set DateTime', () async {
      final key = getUniqueKey();
      var now = DateTime.now();
      var shortStr = now.toString().substring(0, 19);
      final value = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second);
      await prefSetDateTime(key, value);
      var result = await prefGetDateTime(key);
      expect(result.toString().substring(0, 19), shortStr);
      expect(result, value);
      await prefRemoveKey(key);
      expect(await prefGetDateTime(key), null);
      await prefSetDateTime(key, value);
      await prefSetDateTime(key, null);
      expect(await prefGetDateTime(key), null);
    });
  });

  group('[preferences] List and Map', () {
    test('get/set string list', () async {
      final key = getUniqueKey();
      var list = ['a', 'b', 'c'];
      await prefSetStringList(key, list);
      var result = await prefGetStringList(key);
      expect(result![1], 'b');
      await prefRemoveKey(key);
      expect(await prefGetStringList(key), null);
    });

    test('get/set map', () async {
      final key = getUniqueKey();
      Map<String, dynamic> map = {'a': 1, 'b': 2};
      await prefSetMap(key, map);
      var result = await prefGetMap(key);
      expect(result!['b'], 2);
      await prefRemoveKey(key);
      expect(await prefGetMap(key), null);
    });

    test('get/set map list', () async {
      final key = getUniqueKey();
      Map<String, dynamic> map1 = {'a': 1, 'b': 2};
      Map<String, dynamic> map2 = {'a': 'a', 'b': 'b'};
      var list = [map1, map2];
      await prefSetMapList(key, list);
      var result = await prefGetMapList(key);
      expect(result![0]['a'], 1);
      expect(result[1]['a'], 'a');
      expect(result[0]['b'], 2);
      expect(result[1]['b'], 'b');
      await prefRemoveKey(key);
      expect(await prefGetMapList(key), null);
    });
  });
}

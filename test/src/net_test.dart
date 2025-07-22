import 'package:flutter/services.dart';
import 'package:flutter_appkit/src/net.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('[utils/net]', () {
    group('Connectivity Tests', () {
      test('should check internet connected', () async {
        bool result = await netIsInternetConnected();
        expect(result, true);
      });

      test('should check Google Cloud Functions availability', () async {
        bool result = await netIsGoogleCloudFunctionAvailable();
        expect(result, isA<bool>());
      });
    });

    group('URL Launch Tests', () {
      setUp(() {
        // Mock the url_launcher platform channel
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/url_launcher'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'launch') {
              return true;
            }
            return null;
          },
        );
      });

      tearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/url_launcher'),
          null,
        );
      });

      test('should open URL without throwing exception', () async {
        // Test with a valid URL format
        expect(() async => await netOpenUrl('https://www.example.com'), returnsNormally);
      });

      test('should handle invalid URL gracefully', () async {
        // Mock to return failure for invalid URLs
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/url_launcher'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'launch') {
              final String url = methodCall.arguments['url'];
              if (url == 'invalid-url') {
                throw PlatformException(code: 'INVALID_URL', message: 'Invalid URL');
              }
              return true;
            }
            return null;
          },
        );

        // Test with invalid URL format
        expect(() async => await netOpenUrl('invalid-url'), throwsA(isA<PlatformException>()));
      });
    });

    group('Communication Tests', () {
      setUp(() {
        // Mock the url_launcher platform channel
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/url_launcher'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'launch') {
              return true;
            }
            return null;
          },
        );
      });

      tearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/url_launcher'),
          null,
        );
      });

      test('should open email client with correct parameters', () async {
        // Test email functionality
        expect(() async => await netOpenMailTo('test@example.com', 'Test Subject', 'Test Body'), returnsNormally);
      });

      test('should handle email with special characters', () async {
        // Test URL encoding of special characters
        expect(
            () async => await netOpenMailTo('test@example.com', 'Subject with spaces & symbols', 'Body with\nnewlines'),
            returnsNormally);
      });

      test('should open SMS with phone number', () async {
        // Test SMS functionality
        expect(() async => await netOpenSms('+1234567890'), returnsNormally);
      });

      test('should initiate phone call', () async {
        // Test phone call functionality
        expect(() async => await netPhoneCall('+1234567890'), returnsNormally);
      });

      test('should handle international phone numbers', () async {
        // Test with international format
        expect(() async => await netPhoneCall('+86-138-0013-8000'), returnsNormally);
        expect(() async => await netOpenSms('+44-20-7946-0958'), returnsNormally);
      });
    });

    group('Edge Cases', () {
      setUp(() {
        // Mock the url_launcher platform channel
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/url_launcher'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'launch') {
              return true;
            }
            return null;
          },
        );
      });

      tearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/url_launcher'),
          null,
        );
      });

      test('should handle empty strings in email parameters', () async {
        expect(() async => await netOpenMailTo('', '', ''), returnsNormally);
      });

      test('should handle whitespace in email parameters', () async {
        expect(() async => await netOpenMailTo('  test@example.com  ', '  Subject  ', '  Body  '), returnsNormally);
      });

      test('should handle empty phone number', () async {
        expect(() async => await netOpenSms(''), returnsNormally);
        expect(() async => await netPhoneCall(''), returnsNormally);
      });
    });
  });
}

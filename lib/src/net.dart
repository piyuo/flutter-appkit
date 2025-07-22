// ===============================================
// Module: net.dart
// Description: Network utility functions for connectivity checks and URL operations
//
// Sections:
//   - Private Helper Functions
//   - Connectivity Check Functions
//   - URL Launch Functions
//   - Communication Functions
//
// Features:
//   - Internet connectivity detection
//   - Cloud service availability checks
//   - External URL launching
//   - Email, SMS, and phone call integration
// ===============================================

import 'package:universal_io/io.dart';
import 'package:url_launcher/url_launcher.dart';

/// Private helper function to check if a URL can be resolved via DNS lookup.
///
/// Returns `true` if the URL can be successfully looked up, `false` otherwise.
///
/// Example:
/// ```dart
/// bool result = await _lookup('baidu.com');
/// ```
Future<bool> _lookup(String url) async {
  try {
    final result = await InternetAddress.lookup(url);
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } catch (e) {
    // Silently handle lookup failures
  }
  return false;
}

/// Checks if the device has an active internet connection.
///
/// Uses Starbucks.com as a reliable test endpoint for connectivity.
/// Returns `true` if internet is available, `false` otherwise.
///
/// Example:
/// ```dart
/// bool isConnected = await netIsInternetConnected();
/// if (isConnected) {
///   // Proceed with network operations
/// }
/// ```
Future<bool> netIsInternetConnected() async {
  return _lookup('starbucks.com');
}

/// Checks if Google Cloud Functions service is available.
///
/// Useful for determining if Google Cloud services can be reached
/// before attempting to call cloud functions.
///
/// Example:
/// ```dart
/// bool isAvailable = await netIsGoogleCloudFunctionAvailable();
/// if (isAvailable) {
///   // Safe to call Google Cloud Functions
/// }
/// ```
Future<bool> netIsGoogleCloudFunctionAvailable() async {
  return _lookup('www.cloudfunctions.net');
}

/// Opens an external URL in the system's default browser or application.
///
/// The URL will be launched using the platform's default handler.
/// Throws an exception if the URL cannot be launched.
///
/// Example:
/// ```dart
/// await netOpenUrl('https://www.example.com');
/// ```
Future<void> netOpenUrl(String url) async {
  await launchUrl(
    Uri.parse(url),
  );
}

/// Opens the system's email client with pre-populated recipient, subject, and body.
///
/// All parameters are URL-encoded to handle special characters properly.
/// The email client will open with the specified information pre-filled.
///
/// Parameters:
/// - [to]: Email address of the recipient
/// - [subject]: Email subject line (will be trimmed and encoded)
/// - [body]: Email body content (will be trimmed and encoded)
///
/// Example:
/// ```dart
/// await netOpenMailTo(
///   'service@example.com',
///   'Support Request',
///   'Hello, I need help with...'
/// );
/// ```
Future<void> netOpenMailTo(String to, String subject, String body) async {
  to = Uri.encodeComponent(to);
  subject = Uri.encodeComponent(subject.trim());
  body = Uri.encodeComponent(body.trim());
  final url = 'mailto:$to?Subject=$subject&body=$body';
  await netOpenUrl(url);
}

/// Opens the system's SMS application with the specified phone number.
///
/// On mobile devices, this will open the default SMS/messaging app
/// with the phone number pre-filled in the recipient field.
///
/// Parameters:
/// - [phoneNumber]: The phone number to send SMS to (should include country code)
///
/// Example:
/// ```dart
/// await netOpenSms('+1234567890');
/// ```
Future<void> netOpenSms(String phoneNumber) async {
  await netOpenUrl('sms:$phoneNumber');
}

/// Initiates a phone call to the specified phone number.
///
/// On mobile devices with calling capabilities, this will open the phone app
/// and initiate a call to the specified number. On devices without calling
/// capabilities, behavior may vary by platform.
///
/// Parameters:
/// - [phoneNumber]: The phone number to call (should include country code)
///
/// Example:
/// ```dart
/// await netPhoneCall('+1234567890');
/// ```
Future<void> netPhoneCall(String phoneNumber) async {
  await netOpenUrl('tel:$phoneNumber');
}

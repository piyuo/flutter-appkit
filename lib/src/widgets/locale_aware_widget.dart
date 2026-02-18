// ===============================================
// Module: app.dart
// Description: Core initialization function for Flutter AppKit with comprehensive error handling
//
// Sections:
//   - Global State Variables
//   - Main appRun() Function
//   - Error Handler Setup
//   - Error Catching and Processing
//
// Features:
//   - Sentry integration (optional)
//   - Error callback for custom error handling
//   - Riverpod state management setup
//   - Multi-layer error handling
//   - Talker logging integration
//   - Error dialog management
// ===============================================

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/locale_notifier.dart';

class LocaleAwareWidget extends ConsumerWidget {
  const LocaleAwareWidget({super.key, required this.builder});

  final Widget Function(Locale?) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return builder(locale);
  }
}

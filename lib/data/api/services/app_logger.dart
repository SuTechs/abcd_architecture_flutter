import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';

/// Centralized logger for the ABCD Architecture.
///
/// Uses `dart:developer` [log] which:
///   - Is stripped entirely in release builds when guarded by [kDebugMode].
///   - Integrates with DevTools for structured log viewing.
///   - Supports error objects and stack traces natively.
///
/// Usage:
/// ```dart
/// AppLogger.info('User loaded', tag: 'AuthBloc');
/// AppLogger.error('Failed to fetch', tag: 'API', error: e, stack: s);
/// ```
class AppLogger {
  AppLogger._();

  /// Informational messages (level 0).
  static void info(String message, {String tag = 'App'}) {
    if (kDebugMode) {
      dev.log(message, name: tag, level: 0);
    }
  }

  /// Warning messages (level 900).
  static void warning(String message, {String tag = 'App'}) {
    if (kDebugMode) {
      dev.log('⚠️ $message', name: tag, level: 900);
    }
  }

  /// Error messages with optional error object and stack trace (level 1000).
  static void error(
    String message, {
    String tag = 'App',
    Object? error,
    StackTrace? stack,
  }) {
    if (kDebugMode) {
      dev.log(
        '❌ $message',
        name: tag,
        level: 1000,
        error: error,
        stackTrace: stack,
      );
    }
  }
}

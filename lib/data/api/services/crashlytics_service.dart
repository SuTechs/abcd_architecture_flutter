import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import 'app_logger.dart';

/// Firebase Crashlytics wrapper with mock fallback.
///
/// When Firebase is not initialized (e.g. mock backend), errors
/// are logged via [AppLogger] instead of crashing.
class CrashlyticsService {
  static bool _initialized = false;

  /// Call after Firebase.initializeApp() succeeds.
  static void markInitialized() => _initialized = true;

  /// Set up global error handlers after app bootstrap.
  /// If Firebase was initialized during bootstrap, errors go to Crashlytics.
  /// Otherwise, errors fall back to [AppLogger].
  static void setupErrorHandlers() {
    if (_initialized && !kIsWeb) {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    } else {
      FlutterError.onError = (details) {
        AppLogger.error(
          'Flutter error',
          tag: 'Crashlytics',
          error: details.exception,
          stack: details.stack,
        );
        FlutterError.presentError(details);
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        AppLogger.error(
          'Uncaught error',
          tag: 'Crashlytics',
          error: error,
          stack: stack,
        );
        return true;
      };
    }
  }

  static Future<void> setUserId(String id) async {
    if (_initialized && !kIsWeb) {
      try {
        await FirebaseCrashlytics.instance.setUserIdentifier(id);
      } catch (_) {}
    }
  }

  static Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
  }) async {
    if (_initialized && !kIsWeb) {
      try {
        await FirebaseCrashlytics.instance.recordError(
          exception,
          stack,
          reason: reason,
        );
      } catch (_) {}
    } else {
      AppLogger.error(
        'Recorded error',
        tag: 'Crashlytics',
        error: exception,
        stack: stack,
      );
    }
  }
}

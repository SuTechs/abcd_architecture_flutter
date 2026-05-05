import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

import 'app_logger.dart';

/// Firebase Analytics wrapper with mock fallback.
///
/// When Firebase is not initialized (e.g. mock backend), events
/// are logged via [AppLogger] instead of crashing.
class AnalyticsService {
  static bool _initialized = false;

  /// Call after Firebase.initializeApp() succeeds.
  static void markInitialized() => _initialized = true;

  static Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    if (_initialized && !kIsWeb) {
      try {
        await FirebaseAnalytics.instance.logEvent(
          name: name,
          parameters: parameters,
        );
      } catch (e) {
        AppLogger.error('logEvent failed', tag: 'Analytics', error: e);
      }
    } else {
      AppLogger.info('$name ${parameters ?? ''}', tag: 'Analytics');
    }
  }

  static Future<void> setUserId(String id) async {
    if (_initialized && !kIsWeb) {
      try {
        await FirebaseAnalytics.instance.setUserId(id: id);
      } catch (_) {}
    }
    AppLogger.info('setUserId: $id', tag: 'Analytics');
  }

  static Future<void> logScreenView(String screenName) async {
    if (_initialized && !kIsWeb) {
      try {
        await FirebaseAnalytics.instance.logScreenView(screenName: screenName);
      } catch (_) {}
    }
    AppLogger.info('screen: $screenName', tag: 'Analytics');
  }
}

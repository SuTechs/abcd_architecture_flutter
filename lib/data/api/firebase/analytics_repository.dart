import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsRepository {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: _analytics);

  /// Log Events
  Future<void> _logEvent(String name, [Map<String, Object>? parameters]) async {
    try {
      log('Hello: logging event $name');

      await _analytics.logEvent(
        name: name.toLowerCase().replaceAll(' ', '_'),
        parameters: parameters,
      );
    } catch (e) {
      log('[Analytics Error] $e');
    }
  }

//  /// use observer to log screen view
// /// Log Screen View
// Future<void> _logScreenView(String name, String screenClass,
//     [Map<String, Object>? parameters]) async {
//   try {
//     log('Hello: logging event $name');
//
//     // log screen view
//     await _analytics.logScreenView(
//       screenName: name.toLowerCase().replaceAll(' ', '_'),
//       screenClass: screenClass,
//       parameters: parameters,
//     );
//   } catch (e) {
//     log('[Analytics Error] $e');
//   }
// }
}

/// Button Click Events
class ButtonClickEvents extends AnalyticsRepository {
  // log out button click
  Future<void> logOutButtonClick() => _logEvent("Log Out Button Click");
}

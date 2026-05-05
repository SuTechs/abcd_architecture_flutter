import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

import '../services/app_logger.dart';
import '../services/analytics_service.dart';
import '../services/crashlytics_service.dart';

class FirebaseInit {
  static Future<bool> initialize() async {
    try {
      // NOTE: User must run `flutterfire configure` to generate firebase_options.dart
      // If no options are provided, this assumes the native platforms are already configured.
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }

      if (!kDebugMode) {
        await FirebaseAppCheck.instance.activate(
          androidProvider: AndroidProvider.playIntegrity,
          appleProvider: AppleProvider.deviceCheck,
        );
      } else {
        await FirebaseAppCheck.instance.activate(
          androidProvider: AndroidProvider.debug,
          appleProvider: AppleProvider.debug,
        );
      }

      AnalyticsService.markInitialized();
      CrashlyticsService.markInitialized();
      return true;
    } catch (e) {
      AppLogger.error(
        'Firebase init error (Did you run flutterfire configure?)',
        tag: 'FirebaseInit',
        error: e,
      );
      return false;
    }
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_update/in_app_update.dart';

class InAppUpdateCommand {
  static Future<void> checkAndPerformUpdate() async {
    try {
      if (!Platform.isAndroid || !kReleaseMode) return;

      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        await InAppUpdate.performImmediateUpdate();
        // The app will restart after the update is installed
      }
    } catch (e, s) {
      log('Error = $e and stacktrace = $s');
    }
  }
}

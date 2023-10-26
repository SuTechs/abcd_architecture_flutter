import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

_Dispatcher _logHistory = _Dispatcher("");

void log(String? value) {
  String v = value ?? "";
  _logHistory.value = "$v\n${_logHistory.value}";
  if (kDebugMode) {
    debugPrint(v);
  }
}

void logCrashlytics(String? value) {
  if (value == null || value.isEmpty) return;

  FirebaseCrashlytics.instance.log("[logCrashlytics] $value");
}

void logError(String? value) => log("[ERROR] ${value ?? ""}");

// Take from: https://flutter.dev/docs/testing/errors
void initLogger(VoidCallback runApp) {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
      logError(details.stack.toString());

      if (!kDebugMode) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      }
    };
    runApp.call();
  }, (Object error, StackTrace stack) {
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }

    logError(stack.toString());
  });
}

class _Dispatcher extends ValueNotifier<String> {
  _Dispatcher(String value) : super(value);
}

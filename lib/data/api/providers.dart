import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/base_api_service.dart';
import 'local/hive_storage_service.dart';
import 'local/local_storage_service.dart';
import 'mock/mock_service.dart';

/// ── API Service Provider ───────────────────────────────────
///
/// Controls which backend the entire app uses.
/// Default: [MockService] (safe for demo/testing).
///
/// To switch backends, override in `main.dart`:
/// ```dart
/// ProviderScope(
///   overrides: [
///     apiServiceProvider.overrideWithValue(FirebaseService()),
///   ],
///   child: MyApp(),
/// )
/// ```
final apiServiceProvider = Provider<BaseApiService>((ref) {
  return MockService();
});

/// ── Local Storage Provider ─────────────────────────────────
///
/// Provides [HiveStorageService] by default.
final localStorageProvider = Provider<LocalStorageService>((ref) {
  return HiveStorageService();
});

/// Abstract local storage service for KV storage and JSON caching.
///
/// Implementations: [HiveStorageService]
abstract class LocalStorageService {
  /// Initialize the storage engine.
  Future<void> init();

  // ── Bool KV ──────────────────────────────────────────────
  Future<void> setBool(String key, bool value);
  bool? getBool(String key);

  // ── String KV ────────────────────────────────────────────
  Future<void> setString(String key, String value);
  String? getString(String key);

  // ── JSON cache (for offline support) ─────────────────────
  Future<void> cacheJson(String key, Map<String, dynamic> json);
  Map<String, dynamic>? getCachedJson(String key);

  // ── List<JSON> cache ─────────────────────────────────────
  Future<void> cacheJsonList(String key, List<Map<String, dynamic>> list);
  List<Map<String, dynamic>>? getCachedJsonList(String key);

  // ── Cleanup ──────────────────────────────────────────────
  Future<void> remove(String key);
  Future<void> clearAll();
}

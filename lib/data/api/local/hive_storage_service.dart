import 'dart:convert';

import 'package:hive_ce_flutter/hive_flutter.dart';

import 'local_storage_service.dart';

/// Hive CE implementation of [LocalStorageService].
///
/// Uses separate boxes for bools, strings, and JSON cache.
class HiveStorageService implements LocalStorageService {
  static const _boolBox = 'abcd_bool';
  static const _stringBox = 'abcd_string';
  static const _jsonBox = 'abcd_json';

  late Box<bool> _bools;
  late Box<String> _strings;
  late Box<String> _jsons;

  @override
  Future<void> init() async {
    await Hive.initFlutter();
    _bools = await Hive.openBox<bool>(_boolBox);
    _strings = await Hive.openBox<String>(_stringBox);
    _jsons = await Hive.openBox<String>(_jsonBox);
  }

  // ── Bool ──────────────────────────────────────────────────

  @override
  Future<void> setBool(String key, bool value) => _bools.put(key, value);

  @override
  bool? getBool(String key) => _bools.get(key);

  // ── String ────────────────────────────────────────────────

  @override
  Future<void> setString(String key, String value) => _strings.put(key, value);

  @override
  String? getString(String key) => _strings.get(key);

  // ── JSON cache ────────────────────────────────────────────

  @override
  Future<void> cacheJson(String key, Map<String, dynamic> json) =>
      _jsons.put(key, jsonEncode(json));

  @override
  Map<String, dynamic>? getCachedJson(String key) {
    final raw = _jsons.get(key);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  @override
  Future<void> cacheJsonList(String key, List<Map<String, dynamic>> list) =>
      _jsons.put(key, jsonEncode(list));

  @override
  List<Map<String, dynamic>>? getCachedJsonList(String key) {
    final raw = _jsons.get(key);
    if (raw == null) return null;
    final decoded = jsonDecode(raw) as List;
    return decoded.cast<Map<String, dynamic>>();
  }

  // ── Cleanup ───────────────────────────────────────────────

  @override
  Future<void> remove(String key) async {
    await _bools.delete(key);
    await _strings.delete(key);
    await _jsons.delete(key);
  }

  @override
  Future<void> clearAll() async {
    await _bools.clear();
    await _strings.clear();
    await _jsons.clear();
  }
}

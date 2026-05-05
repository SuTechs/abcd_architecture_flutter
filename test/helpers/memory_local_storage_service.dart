import 'package:abcd_architecture_flutter/data/api/local/local_storage_service.dart';

class MemoryLocalStorageService implements LocalStorageService {
  final Map<String, bool> _bools = {};
  final Map<String, String> _strings = {};
  final Map<String, Map<String, dynamic>> _jsons = {};
  final Map<String, List<Map<String, dynamic>>> _jsonLists = {};

  @override
  Future<void> init() async {}

  @override
  Future<void> setBool(String key, bool value) async {
    _bools[key] = value;
  }

  @override
  bool? getBool(String key) => _bools[key];

  @override
  Future<void> setString(String key, String value) async {
    _strings[key] = value;
  }

  @override
  String? getString(String key) => _strings[key];

  @override
  Future<void> cacheJson(String key, Map<String, dynamic> json) async {
    _jsons[key] = Map<String, dynamic>.from(json);
  }

  @override
  Map<String, dynamic>? getCachedJson(String key) {
    final value = _jsons[key];
    if (value == null) return null;
    return Map<String, dynamic>.from(value);
  }

  @override
  Future<void> cacheJsonList(
    String key,
    List<Map<String, dynamic>> list,
  ) async {
    _jsonLists[key] = list.map(Map<String, dynamic>.from).toList();
  }

  @override
  List<Map<String, dynamic>>? getCachedJsonList(String key) {
    final value = _jsonLists[key];
    if (value == null) return null;
    return value.map(Map<String, dynamic>.from).toList();
  }

  @override
  Future<void> remove(String key) async {
    _bools.remove(key);
    _strings.remove(key);
    _jsons.remove(key);
    _jsonLists.remove(key);
  }

  @override
  Future<void> clearAll() async {
    _bools.clear();
    _strings.clear();
    _jsons.clear();
    _jsonLists.clear();
  }
}

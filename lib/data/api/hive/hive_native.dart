import 'package:hive_flutter/hive_flutter.dart';

import '../../data/user.dart';
import 'hive_service.dart';

class NativeHiveService extends HiveService {
  @override
  Future<void> init() async {
    /// init hive
    await Hive.initFlutter();

    /// register adapters
    await _registerAdapters();

    /// open box
    await _openBox();
  }

  /// register adapters for all custom data types and hive objets
  static Future<void> _registerAdapters() async {
    Hive.registerAdapter(UserDataAdapter());
    // add more adapters here
  }

  /// open box for all custom data types and hive objets
  static Future<void> _openBox() async {
    // await Hive.openBox<String>('String');

    await Hive.openBox<UserData>('UserData');
    // add more boxes here
  }

  /// get opened box
  @override
  Box<T> box<T>() {
    return Hive.box<T>(T.toString());
  }

// @override
// Box<String> get stringBox => box<String>();
}

import 'package:hive_flutter/adapters.dart';

import '../../data/user/user.dart';
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
    await Hive.openBox<String>('String');
    await Hive.openBox<bool>("bool");

    await Hive.openBox<UserData>('UserData');

    // add more boxes here
  }

  /// get opened box
  @override
  Box<T> box<T>() {
    return Hive.box<T>(T.toString());
  }

  // reset hive
  @override
  void reset() {
    // clear user data
    box<UserData>().clear();

    box<bool>().clear();
    stringBox.clear();
  }

  @override
  Box<String> get stringBox => box<String>();

  @override
  Box<bool> get boolBox => box<bool>();
}

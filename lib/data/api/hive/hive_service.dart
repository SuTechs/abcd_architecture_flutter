import 'package:hive/hive.dart';

import 'hive_native.dart';

class HiveFactory {
  static bool _initComplete = false;

  static Future<HiveService> create() async {
    final HiveService service = NativeHiveService();
    if (_initComplete == false) {
      await service.init();
      _initComplete = true;
    }
    return service;
  }
}

abstract class HiveService {
  ///////////////////////////////////////////////////
  // Abstract Methods
  //////////////////////////////////////////////////

  // init hive
  Future<void> init();

  // get opened box
  Box<T> box<T>();

  void reset();

  Box<String> get stringBox;

  Box<bool> get boolBox;
}

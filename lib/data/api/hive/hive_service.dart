import 'package:hive/hive.dart';

import '../../data/user.dart';
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
  /// /////////////////////////////////////////////////
  /// Concrete Methods
  /// //////////////////////////////////////////////////

  Future<void> saveUser(UserData user) async {
    await box<UserData>().put('currentUser', user);
  }

  UserData? get getSavedUserData => box<UserData>().get('currentUser');

  Future<void> logOut() async {
    await box<UserData>().delete('currentUser');
  }

  ///////////////////////////////////////////////////
  // Abstract Methods
  //////////////////////////////////////////////////

  // init hive
  Future<void> init();

  // get opened box
  Box<T> box<T>();

// Box<String> get stringBox;
}

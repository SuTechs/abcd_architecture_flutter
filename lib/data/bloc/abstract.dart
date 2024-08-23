import 'package:flutter/foundation.dart';

abstract class AbstractBloc extends ChangeNotifier {
  List<T> copyList<T>(List<T>? list) => List.from(list ?? []);

  void notify([VoidCallback? action]) {
    action?.call();
    notifyListeners();
  }
}

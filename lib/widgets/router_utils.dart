import 'package:flutter/material.dart';

Future<T?> goTo<T extends Object?>(Widget page, BuildContext context) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}

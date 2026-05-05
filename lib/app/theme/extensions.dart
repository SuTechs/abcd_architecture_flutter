import 'package:flutter/material.dart';

extension BuildContextThemeX on BuildContext {
  // Theme shorthands
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  // Screen size shorthands
  Size get screenSize => MediaQuery.sizeOf(this);
  bool get isMobile => screenSize.width < 600;
  bool get isTablet => screenSize.width >= 600 && screenSize.width < 1024;
  bool get isDesktop => screenSize.width >= 1024;

  // Snackbar shorthand
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              color: isError
                  ? colorScheme.onError
                  : colorScheme.onInverseSurface,
            ),
          ),
          backgroundColor: isError
              ? colorScheme.error
              : colorScheme.inverseSurface,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

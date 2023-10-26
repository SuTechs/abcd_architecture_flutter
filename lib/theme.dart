import 'package:flutter/material.dart';

import 'constants.dart';

class AppTheme {
  static Color get seedColor => kPurpleSeedColor;

  static ThemeData lightTheme(ColorScheme? lightColorScheme) {
    return _getFinalTheme(ThemeData(
      // fontFamily: 'OpenSans',
      colorScheme:
          lightColorScheme ?? ColorScheme.fromSeed(seedColor: seedColor),
    ));
  }

  static ThemeData darkTheme(ColorScheme? darkColorScheme) {
    return _getFinalTheme(ThemeData(
      // fontFamily: 'OpenSans',
      colorScheme: darkColorScheme ??
          ColorScheme.fromSeed(
              seedColor: seedColor, brightness: Brightness.dark),
    ));
  }

  /// Override colors or theme globally here
  // no need to manually add background color in scaffold
  // or appbar in each screen or giving elevation or iconTheme etc,
  // everything can be customized here
  static ThemeData _getFinalTheme(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    final backgroundColor = Color.alphaBlend(
        colorScheme.primary.withOpacity(0.08), colorScheme.surface);

    return theme.copyWith(
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: backgroundColor,
        // foregroundColor: colorScheme.primary,
        iconTheme: theme.iconTheme.copyWith(opacity: 0.75),
        // titleTextStyle: TextStyle(color: colorScheme.onBackground),
        elevation: 0.0,
      ),

      /// color scheme override
      colorScheme: colorScheme.copyWith(
        background: backgroundColor,
      ),
    );
  }
}

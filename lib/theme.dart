import 'package:flutter/material.dart';

import 'constants.dart';

class AppTheme {
  static Color get seedColor => kPurpleSeedColor;

  static ThemeData lightTheme(ColorScheme? lightColorScheme) {
    return _getFinalTheme(
      ThemeData(
        // fontFamily: 'DIN',
        colorScheme:
            lightColorScheme ?? ColorScheme.fromSeed(seedColor: seedColor),
      ),
    );
  }

  static ThemeData darkTheme(ColorScheme? darkColorScheme) {
    return _getFinalTheme(
      ThemeData(
        // fontFamily: 'DIN',
        colorScheme: darkColorScheme ??
            ColorScheme.fromSeed(
              seedColor: seedColor,
              brightness: Brightness.dark,
            ),
      ),
    );
  }

  /// Override colors or theme globally here
  // no need to manually add background color in scaffold
  // or appbar in each screen or giving elevation or iconTheme etc,
  // everything can be customized here
  static ThemeData _getFinalTheme(ThemeData theme) {
    // final colorScheme = theme.colorScheme;
    //
    // final backgroundColor = Color.alphaBlend(
    //     colorScheme.primary.withOpacity(0.08), colorScheme.surface);

    return theme.copyWith(
        // scaffoldBackgroundColor: backgroundColor,
        // appBarTheme: AppBarTheme(
        //   centerTitle: true,
        //   backgroundColor: backgroundColor,
        //   // foregroundColor: colorScheme.primary,
        //   iconTheme: theme.iconTheme.copyWith(opacity: 0.75),
        //   // titleTextStyle: TextStyle(color: colorScheme.onBackground),
        //   elevation: 0.0,
        // ),
        //
        // /// color scheme override
        // colorScheme: colorScheme.copyWith(
        //   surface: backgroundColor,
        // ),
        );
  }
}

//
extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  void showSnackBar(String message) => ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );

  void showSnackBarWithAction(
          String message, String actionLabel, VoidCallback onPressed) =>
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(
            label: actionLabel,
            onPressed: onPressed,
          ),
        ),
      );
}

extension ScreenSizeExtension on BuildContext {
  double get height => MediaQuery.sizeOf(this).height;

  double get width => MediaQuery.sizeOf(this).width;

  /// breakpoints

  bool get isMobile => width < 768;

  bool get isTablet => width >= 768 && width < 1200;

  bool get isDesktop => width >= 1200;

  /// get horizontal body padding
  EdgeInsets get horizontalBodyPadding {
    return EdgeInsets.symmetric(horizontal: gutterBodyWidth);
  }

  double get gutterBodyWidth {
    if (isMobile) return 16;

    if (isTablet) return 100;

    return 200;
  }

  /// Gutters

  // gutter small
  double get gutterSmall => value(
        mobile: 8,
        tablet: 16,
        desktop: 24,
      );

  // gutter medium
  double get gutterMedium => value(
        mobile: 16,
        tablet: 24,
        desktop: 32,
      );

  // gutter large
  double get gutterLarge => value(
        mobile: 24,
        tablet: 32,
        desktop: 48,
      );

  /// a function to get value based on screen size
  /// Using mobile first approach, if tablet or desktop value is not provided,
  /// it will fallback to mobile value
  T value<T>({
    required T mobile,
    required T? tablet,
    required T? desktop,
  }) {
    if (isMobile) return mobile;

    if (isTablet) return tablet ?? mobile;

    return desktop ?? mobile;
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;
import 'package:uuid/uuid.dart';

class StringUtils {
  static bool isEmpty(String? s) => s == null || s.trim().isEmpty;

  static bool isNotEmpty(String? s) => !isEmpty(s);

  static bool isEmail(String? value) {
    if (isEmpty(value)) return false;
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value!);
  }

  static bool isPhone(String? value) {
    if (isEmpty(value)) return false;
    return RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value!);
  }

  // Measures text using an off-screen canvas. It's not fast, but not overly slow either. Use with (mild) caution :)
  static Size measure(String text, TextStyle style,
      {int maxLines = 1,
      TextDirection direction = TextDirection.ltr,
      double maxWidth = double.infinity}) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: maxLines,
        textDirection: direction)
      ..layout(minWidth: 0, maxWidth: maxWidth);
    return textPainter.size;
  }

  // Measures longest text item in a list of Strings. Useful for things like Dropdown Menu, where you just want to take up as much space as the content requires.
  static double measureLongest(List<String> items, TextStyle style,
      [int? maxItems]) {
    double l = 0;
    if (maxItems != null && maxItems < items.length) {
      items.length = maxItems;
    }
    for (var item in items) {
      double m = measure(item, style).width;
      if (m > l) l = m;
    }
    return l;
  }

  /// Gracefully handles null values, and skips the suffix when null
  static String safeGet(String? value, [String? suffix]) {
    return (value ?? "") + (!isEmpty(value) ? suffix ?? "" : "");
  }

  static String pluralize(String s, int length) {
    if (length == 1) return s;
    return "${s}s";
  }

  static String titleCaseSingle(String s) =>
      '${s[0].toUpperCase()}${s.substring(1)}';

  static String titleCase(String s) =>
      s.split(" ").map(titleCaseSingle).join(" ");

  static String defaultOnEmpty(String? value, String defaultValue) =>
      isEmpty(value) ? defaultValue : value!;

  /// add dots in between the multiple string
  static String convertWithDots(List<String?> list) {
    if (list.isEmpty) return '';
    String result = list.first ?? "";
    for (int i = 1; i < list.length; i++) {
      if (list[i] == null) continue;
      result += " • ${list[i]}";
    }
    return result;
  }

// static String getRandString() {
//    final random = Random.secure();
//    final len = random.nextInt(100);
//    final values = List<int>.generate(len, (i) => random.nextInt(255));
//    return base64UrlEncode(values);
//  }

  static int? getAgeFromDob(String? dob) {
    if (dob == null) return null;
    try {
      final dobDate = DateFormat('dd-MM-yyyy').parse(dob);
      final currentDate = DateTime.now();
      return currentDate.year - dobDate.year;
    } catch (e) {
      debugPrint('hello error while parsing dob $e');
      return null;
    }
  }

  //
  static String get uniqueId => const Uuid().v4().replaceAll('-', '');

  // get formatted currency
  static String getFormattedCurrency(int value) {
    // return NumberFormat.compactSimpleCurrency(locale: "HI").format(value); //20 hajar
    // return NumberFormat.compactSimpleCurrency(locale: "en_IN").format(value); //20T
    return NumberFormat.currency(
            locale: "en_IN", decimalDigits: 0, symbol: '₹') // 20,000
        .format(value);
  }

  static toAmountString(int amount) {
    var f = NumberFormat("##,##,###", "en_IN");
    return "₹ ${f.format(amount)}";
  }

  static getFormattedDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static getLongFormattedDate(DateTime date) {
    return DateFormat('MMM dd, yyyy hh:mm a').format(date);
  }

  static getMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }
}

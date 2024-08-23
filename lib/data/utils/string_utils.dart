import 'dart:math';

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

  static String titleCaseSingle(String s) {
    if (s.isEmpty) return s;

    if (s.length == 1) return s.toUpperCase();

    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

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

  static int random(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  static String getFormattedDuration(Duration duration) {
    String formattedDuration = '';

    if (duration.inDays > 0) {
      formattedDuration += '${duration.inDays}d ';
    }

    if (duration.inHours % 24 > 0 || duration.inDays > 0) {
      formattedDuration += '${duration.inHours % 24}h ';
    }

    if (duration.inMinutes % 60 > 0 || duration.inHours > 0) {
      formattedDuration += '${duration.inMinutes % 60}m';
    }

    if (formattedDuration.trim().isEmpty) return "0:00";
    return formattedDuration.trim();
  }
}

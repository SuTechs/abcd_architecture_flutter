import 'package:timeago/timeago.dart' as timeago;

class TimeUtils {
  static int get nowMillis => DateTime.now().millisecondsSinceEpoch;

  static int get nowSeconds => (nowMillis * .001).round();

  static String timeAgoFromMillis(int millis) =>
      timeago.format(DateTime.fromMillisecondsSinceEpoch(millis));

  static bool isToday(int dateInMillis) {
    final now = DateTime.now();
    final dateTime = DateTime.fromMillisecondsSinceEpoch(dateInMillis);

    return now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day;
  }

  static bool isYesterday(int dateInMillis) {
    final now = DateTime.now();
    final dateTime = DateTime.fromMillisecondsSinceEpoch(dateInMillis);

    return now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day - 1 == dateTime.day;
  }
}

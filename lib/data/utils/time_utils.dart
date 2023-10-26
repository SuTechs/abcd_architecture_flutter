import 'package:timeago/timeago.dart' as timeago;

class TimeUtils {
  static int get nowMillis => DateTime.now().millisecondsSinceEpoch;

  static int get nowSeconds => (nowMillis * .001).round();

  static String timeAgoFromMillis(int millis) =>
      timeago.format(DateTime.fromMillisecondsSinceEpoch(millis));
}

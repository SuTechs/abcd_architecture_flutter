import 'package:firebase_messaging/firebase_messaging.dart';

import 'app_logger.dart';

class FcmService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    // Request permissions for iOS
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      AppLogger.info('User granted FCM permission', tag: 'FcmService');
    }

    // Get token
    String? token = await _messaging.getToken();
    AppLogger.info('FCM Token: $token', tag: 'FcmService');

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AppLogger.info(
        'Got a message whilst in the foreground!',
        tag: 'FcmService',
      );
      if (message.notification != null) {
        AppLogger.info(
          'Notification: ${message.notification?.title}',
          tag: 'FcmService',
        );
      }
    });
  }
}

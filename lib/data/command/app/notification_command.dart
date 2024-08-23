import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationCommand {
  // request permission
  static Future<void> requestPermission() async {
    try {
      await FirebaseMessaging.instance.requestPermission();
      FirebaseInAppMessaging.instance;

      // // subscribe to topic
      // await messaging.subscribeToTopic('all');
    } on Exception catch (e, s) {
      debugPrint('Failed to request permission: $e and $s');
    }

    final token = await FirebaseMessaging.instance.getToken();

    print('hello token: $token');
  }
}

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // // If you're going to use other Firebase services in the background, such as Firestore,
//   // // make sure you call `initializeApp` before using other Firebase services.
//   // await Firebase.initializeApp();
//
//   print("Handling a background message: ${message.messageId}");
// }

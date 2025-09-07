import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void sendNotification({required String title, required String body}) {
    flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails("channelId", "channelName"),
      ),
    );
  }

  static void askForNotificationPermission() {
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      carPlay: true,
    );
  }
}

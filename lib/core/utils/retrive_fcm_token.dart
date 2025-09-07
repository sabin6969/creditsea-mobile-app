import 'package:firebase_messaging/firebase_messaging.dart';

Future<String?> retriveFcmToken() async {
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    return token;
  } catch (e) {
    return null;
  }
}

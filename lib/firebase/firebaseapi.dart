import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print("fcmToken $fCMToken");
    FirebaseMessaging.onBackgroundMessage(handlebackgroundMessage);
  }

  Future<void> handlebackgroundMessage(RemoteMessage message) async {
    print('title : ${message.notification?.title}');
    print('body : ${message.notification?.body}');
  }
}

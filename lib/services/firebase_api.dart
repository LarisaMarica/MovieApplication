import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await _firebaseMessaging.requestPermission();
    await _firebaseMessaging.getToken();
    print('FCM Token: ${await _firebaseMessaging.getToken()}');
  }
}

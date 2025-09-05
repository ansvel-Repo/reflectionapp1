import 'package:ansvel/homeandregistratiodesign/services/local_notification_service.dart';
// import 'package:ansvel/services/local_notification_service.dart'; // Import the new service
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final Random _random = Random();

  Future<void> initialize() async {
    // Initialize the local notifications plugin
    await LocalNotificationService().initialize();
    
    await _fcm.requestPermission();
    final fcmToken = await _fcm.getToken();
    print("FCM Token: $fcmToken");

    if (fcmToken != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).set(
          {'fcmToken': fcmToken},
          SetOptions(merge: true),
        );
      }
    }

    // This is where the comment is implemented
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      final notification = message.notification;
      if (notification != null) {
        // Use the LocalNotificationService to show an in-app banner
        LocalNotificationService().showNotification(
          id: _random.nextInt(1000), // A random ID for each notification
          title: notification.title ?? 'New Notification',
          body: notification.body ?? '',
        );
      }
    });
  }

  
}
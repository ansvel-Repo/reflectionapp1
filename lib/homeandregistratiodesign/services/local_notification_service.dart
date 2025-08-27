import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  // Singleton pattern to ensure a single instance
  static final LocalNotificationService _instance = LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Initialization settings for Android
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@drawable/app_icon'); // Uses the icon from step 2

    // Initialization settings for iOS
    const DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'ansvel-channel-id', // A unique channel ID
      'Ansvel Notifications',
      channelDescription: 'Notifications for transactions and alerts',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }
}
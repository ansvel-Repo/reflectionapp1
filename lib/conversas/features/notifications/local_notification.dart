import 'package:ansvel/conversas/common/common.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final LocalNotificationService _notificationService =
      LocalNotificationService._internal();
  factory LocalNotificationService() => _notificationService;

  LocalNotificationService._internal();
  final _flutterLocalNotifications = FlutterLocalNotificationsPlugin();

  Future<void> requestIOSPermission() async {
    _flutterLocalNotifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings(AppKeys.icLauncher);

    final initializationSettingsIOS = DarwinInitializationSettings(
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {},
    );
  }

  Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
  }) async {
    return _flutterLocalNotifications.show(
      id,
      title,
      body,
      await _notificationDetails(),
    );
  }

  _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        AppKeys.chats,
        AppKeys.chats,
        importance: Importance.max,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }
}

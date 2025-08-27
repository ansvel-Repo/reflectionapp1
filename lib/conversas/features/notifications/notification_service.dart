import 'package:ansvel/conversas/common/common.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class NotificationService {
  NotificationService._();

  static final _fmcApiUrl = '${dotenv.env['FCM_API_URL']}';
  static final _fmcServerKey = '${dotenv.env['FCM_SERVER_KEY']}';

  // Notification permissions must be authorized to receive pushes
  static Future<void> requestNotificationPermission(WidgetRef ref) async {
    final fmc = FirebaseMessaging.instance;

    final settings = await fmc.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      //get token for push notification
      getUserToken(ref);

      //background notification
      await _listenForegroundMessage();
    }
  }

  static void getUserToken(WidgetRef ref) async {
    //check users permission
    final isNotificationAllowed = ref.watch(subscribeNotificationProvider);
    final fmc = FirebaseMessaging.instance;
    if (isNotificationAllowed) {
      PushNotificationDataSource.setUserFcmToken();

      // Note: This callback is fired at each
      //app startup and whenever a new token is generated.
      fmc.onTokenRefresh.listen((fcmToken) {
        PushNotificationDataSource.setUserFcmToken();
      });
    } else {
      //unsubscribe user for receiving notifications
      PushNotificationDataSource.deleteUserFcmToken();
    }
  }

  //listen to  message
  static Future<void> _listenForegroundMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        final notification = message.notification;
        if (notification == null) return;

        LocalNotificationService().showNotification(
          id: AppHelpers.generateUniqueId(),
          title: notification.title,
          body: notification.body,
          payLoad: message.data[AppKeys.userId],
        );
      }
    });
  }

  // for sending group push notification
  static Future<bool> sendGroupNotification({
    required String msg,
    required GroupModel group,
    required AppUser sender,
  }) async {
    final fmc = FirebaseMessaging.instance;
    final settings = await fmc.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final data = {
        "notification": {
          "title": '${sender.username} - ${group.name}',
          "body": msg,
        },
        "priority": "high",
        "data": {
          AppKeys.clickAction: "FLUTTER_NOTIFICATION_CLICK",
          AppKeys.groupId: group.groupId,
          AppKeys.type: AppKeys.group,
          AppKeys.status: "done",
        },
        "to": "/topics/${group.groupId}",
      };

      final response = await _makeHttpRequest(data);

      // on failure
      if (response.statusCode != 200) return false;

      // on success
      return true;
    } else {
      return false;
    }
  }

  // for sending push notification
  static Future<bool> sendPushNotification({
    required String msg,
    required String receiverToken,
    required AppUser sender,
    required String type,
  }) async {
    final fmc = FirebaseMessaging.instance;
    final settings = await fmc.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final data = {
        "notification": {"title": sender.username, "body": msg},
        "priority": "high",
        "data": {
          AppKeys.clickAction: "FLUTTER_NOTIFICATION_CLICK",
          AppKeys.senderId: sender.userId,
          AppKeys.type: type,
          AppKeys.status: "done",
        },
        "to": receiverToken,
      };

      final response = await _makeHttpRequest(data);

      // on failure
      if (response.statusCode != 200) return false;

      // on success
      return true;
    } else {
      return false;
    }
  }

  static Future<http.Response> _makeHttpRequest(
    Map<String, dynamic> data,
  ) async {
    final headers = {
      'content-type': 'application/json',
      'Authorization': 'Bearer $_fmcServerKey',
    };

    return await http.post(
      Uri.parse(_fmcApiUrl),
      body: json.encode(data),
      encoding: Encoding.getByName('utf-8'),
      headers: headers,
    );
  }

  static Future<void> setupInteractedMessage(BuildContext context) async {
    // Get any messages which caused the application to open from
    // a terminated state.
    final RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    // navigate to a notification page
    if (context.mounted && initialMessage != null) {
      _handleMessage(initialMessage, context);
    }

    //handle any interaction when the app is in the background via a
    //Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      // navigate to a notification page
      _handleMessage(remoteMessage, context);
    });
  }

  static void _handleMessage(RemoteMessage message, BuildContext context) {
    final data = message.data;

    //if it's a msg go to the personal chat page
    if (data[AppKeys.type] == AppKeys.chat) {
      final userId = '${data[AppKeys.userId]}';

      context.pushNamed(
        RouteLocation.personalChat,
        pathParameters: {AppKeys.receiverId: userId},
      );
    }

    //if is a contact request navigate to notification page
    if (data[AppKeys.type] == AppKeys.request) {
      context.go(RouteLocation.notification);
    }
    //if is a group msg navigate to group chat page
    if (data[AppKeys.type] == AppKeys.group) {
      final groupId = '${data[AppKeys.groupId]}';

      context.pushNamed(
        RouteLocation.groups,
        pathParameters: {AppKeys.groupId: groupId},
      );
    }
  }
}

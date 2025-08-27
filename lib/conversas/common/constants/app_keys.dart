import 'package:flutter/foundation.dart' show immutable;

@immutable
class AppKeys {
  static const String chats = 'chats';
  static const String locale = 'locale';
  static const String userId = 'userId';
  static const String groupId = 'groupId';
  static const String emailScope = 'email';
  static const String googleCom = 'google.com';
  static const String isDarkMode = 'isDarkMode';
  static const String receiverId = 'receiverId';
  static const String isLoggedIn = 'isLoggedIn';
  static const String icLauncher = 'ic_launcher';
  static const String currentUserId = 'currentUserId';

  //notifications keys
  static const String subscribing = 'subscribing';
  static const String clickAction = 'click_action';
  static const String senderId = 'senderId';
  static const String request = 'request';
  static const String status = 'status';
  static const String type = 'type';
  static const String chat = 'chat';
  static const String group = 'group';

  const AppKeys._();
}

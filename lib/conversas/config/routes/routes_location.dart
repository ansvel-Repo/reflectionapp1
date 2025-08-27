import 'package:flutter/foundation.dart' show immutable;

@immutable
class RouteLocation {
  const RouteLocation._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgetPassword = '/forgetPassword';

  //NavBottom
  static const String notification = '/notification';
  static const String contacts = '/contacts';
  static const String chats = '/chats';
  static const String settings = '/settings';
  //Fim NavBottom

  //
  static const String addContact = '/addContact';

  //chat
  static const String personalChat = '/personalChat';
  static const String createGroup = '/createGroup';
  static const String addParticipants = '/addParticipants';
  static const String groups = '/groups';
  static const String groupInfo = '/groupInfo';

  //
  static const String appVersion = '/appVersion';

  //story
  static const String userStories = '/userStories';
  static const String addStory = '/addStory';

  //delete account
  static const String deleteAccount = '/deleteAccount';

  //profile
  static const String contactDetails = '/contactDetails';
}

import 'package:flutter/foundation.dart' show immutable;

@immutable
class FirebaseFieldName {
  //app user
  static const String email = 'email';
  static const String about = 'about';
  static const String userId = 'userId';
  static const String isOnline = 'isOnline';
  static const String username = 'username';
  static const String pushToken = 'pushToken';
  static const String lastActive = 'lastActive';

  //contact
  static const String contactId = 'contactId';
  static const String senderId = 'senderId';
  static const String receiverId = 'receiverId';
  static const String status = 'status';

  //common
  static const String createdAt = 'createdAt';
  static const String imageUrl = 'imageUrl';
  static const String id = 'id';

  //chat
  static const String text = 'text';
  static const String chatId = 'chatId';
  static const String lastMessage = 'lastMessage';
  static const String messageId = 'messageId';
  static const String participants = 'participants';
  static const String lastMessageDate = 'lastMessageDate';
  static const String replyMessage = 'replyMessage';

  //stories
  static const String storyId = 'storyId';
  static const String contentUrl = 'contentUrl';
  static const String viewedBy = 'viewedBy';
  static const String expirationDate = 'expirationDate';

  //groups
  static const String groupId = 'groupId';
  static const String membersIds = 'membersIds';
  static const String adminsIds = 'adminsIds';
  static const String lastActivity = 'lastActivity';
  static const String groupCreator = 'groupCreator';
  static const String name = 'name';

  const FirebaseFieldName._();
}

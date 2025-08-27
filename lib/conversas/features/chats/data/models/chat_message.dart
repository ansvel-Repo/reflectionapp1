import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:ansvel/conversas/common/common.dart';

class ChatMessage extends Equatable {
  final String messageId;
  final String senderId;
  final String receiverId;
  final String chatId;
  final String text;
  final String imageUrl;
  final ChatMessage? replyMessage;
  final Timestamp createdAt;

  const ChatMessage({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.imageUrl,
    required this.chatId,
    this.replyMessage,
    required this.createdAt,
  });

  @override
  List<Object> get props {
    return [
      messageId,
      senderId,
      text,
      imageUrl,
      chatId,
      receiverId,
      //replyMessage,
      createdAt,
    ];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      FirebaseFieldName.messageId: messageId,
      FirebaseFieldName.senderId: senderId,
      FirebaseFieldName.text: text,
      FirebaseFieldName.imageUrl: imageUrl,
      FirebaseFieldName.createdAt: createdAt,
      FirebaseFieldName.chatId: chatId,
      FirebaseFieldName.receiverId: receiverId,
      FirebaseFieldName.replyMessage: replyMessage?.toJson(),
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> map) {
    final replyMessage = map[FirebaseFieldName.replyMessage];

    return ChatMessage(
      messageId: map[FirebaseFieldName.messageId] ?? '',
      senderId: map[FirebaseFieldName.senderId] ?? '',
      text: map[FirebaseFieldName.text] ?? '',
      chatId: map[FirebaseFieldName.chatId] ?? '',
      receiverId: map[FirebaseFieldName.receiverId] ?? '',
      imageUrl: map[FirebaseFieldName.imageUrl] ?? '',
      createdAt: map[FirebaseFieldName.createdAt] as Timestamp,
      replyMessage: replyMessage != null
          ? ChatMessage.fromJson(replyMessage as Map<String, dynamic>)
          : null,
    );
  }

  ChatMessage copyWith({
    String? messageId,
    String? senderId,
    String? receiverId,
    String? chatId,
    String? text,
    String? imageUrl,
    ChatMessage? replyMessage,
    Timestamp? createdAt,
  }) {
    return ChatMessage(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      chatId: chatId ?? this.chatId,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      replyMessage: replyMessage ?? this.replyMessage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

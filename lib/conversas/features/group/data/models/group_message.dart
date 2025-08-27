import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:ansvel/conversas/common/common.dart';

class GroupMessage extends Equatable {
  final String messageId;
  final String senderId;
  final String groupId;
  final String text;
  final String imageUrl;
  final GroupMessage? replyMessage;
  final Timestamp createdAt;

  const GroupMessage({
    required this.messageId,
    required this.senderId,
    required this.groupId,
    required this.text,
    required this.imageUrl,
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
      groupId,
      //replyMessage,
      createdAt,
    ];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      FirebaseFieldName.messageId: messageId,
      FirebaseFieldName.senderId: senderId,
      FirebaseFieldName.groupId: groupId,
      FirebaseFieldName.text: text,
      FirebaseFieldName.imageUrl: imageUrl,
      FirebaseFieldName.createdAt: createdAt,
      FirebaseFieldName.receiverId: groupId,
      FirebaseFieldName.replyMessage: replyMessage?.toJson(),
    };
  }

  factory GroupMessage.fromJson(Map<String, dynamic> map) {
    final replyMessage = map[FirebaseFieldName.replyMessage];

    return GroupMessage(
      messageId: map[FirebaseFieldName.messageId] ?? '',
      senderId: map[FirebaseFieldName.senderId] ?? '',
      text: map[FirebaseFieldName.text] ?? '',
      groupId: map[FirebaseFieldName.receiverId] ?? '',
      imageUrl: map[FirebaseFieldName.imageUrl] ?? '',
      createdAt: map[FirebaseFieldName.createdAt] as Timestamp,
      replyMessage: replyMessage != null
          ? GroupMessage.fromJson(replyMessage as Map<String, dynamic>)
          : null,
    );
  }

  GroupMessage copyWith({
    String? messageId,
    String? senderId,
    String? groupId,
    String? text,
    String? imageUrl,
    GroupMessage? replyMessage,
    Timestamp? createdAt,
  }) {
    return GroupMessage(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      groupId: groupId ?? this.groupId,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      replyMessage: replyMessage ?? this.replyMessage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

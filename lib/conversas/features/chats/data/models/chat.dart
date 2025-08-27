import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:ansvel/conversas/common/common.dart';

class Chat extends Equatable {
  final String chatId;
  final List<String> participants;
  final String lastMessage;
  final Timestamp lastMessageDate;
  final Timestamp createdAt;

  const Chat({
    required this.chatId,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageDate,
    required this.createdAt,
  });

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [chatId, participants, lastMessage, createdAt];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      FirebaseFieldName.chatId: chatId,
      FirebaseFieldName.participants: participants,
      FirebaseFieldName.lastMessage: lastMessage,
      FirebaseFieldName.createdAt: createdAt,
      FirebaseFieldName.lastMessageDate: lastMessageDate,
    };
  }

  factory Chat.fromJson(Map<String, dynamic> map) {
    return Chat(
      chatId: map[FirebaseFieldName.chatId] as String,
      participants: List<String>.from(
        (map[FirebaseFieldName.participants] ?? []),
      ),
      lastMessage: map[FirebaseFieldName.lastMessage] as String,
      createdAt: map[FirebaseFieldName.createdAt] as Timestamp,
      lastMessageDate:
          map[FirebaseFieldName.lastMessageDate] ?? Timestamp.now(),
    );
  }

  Chat copyWith({
    String? chatId,
    List<String>? participants,
    String? lastMessage,
    Timestamp? lastMessageDate,
    Timestamp? createdAt,
  }) {
    return Chat(
      chatId: chatId ?? this.chatId,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageDate: lastMessageDate ?? this.lastMessageDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

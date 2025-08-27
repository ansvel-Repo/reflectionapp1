import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:image_picker/image_picker.dart';

class ChatsRepositoryImpl implements ChatsRepository {
  final ChatsDataSource _datasource;

  ChatsRepositoryImpl(this._datasource);

  @override
  Stream<Chat?> getChatByParticipantId(String participantId) async* {
    try {
      final result = _datasource.getChatByParticipantId(participantId);

      yield* result.map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          final doc = snapshot.docs.first;
          return Chat.fromJson(doc.data() as Map<String, dynamic>);
        } else {
          return null;
        }
      });
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Future<void> sendMessage(ChatMessage message, XFile? image) async {
    try {
      await _datasource.sendMessage(message, image);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Stream<bool> hasChatMessages(String chatId) async* {
    try {
      yield* _datasource.hasChatMessages(chatId);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Future<void> deleteMessage(String chatId, ChatMessage message) async {
    try {
      await _datasource.deleteMessage(chatId, message);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Future<void> deleteChat(String chatId) async {
    try {
      await _datasource.deleteChat(chatId);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Stream<Chat?> getChatById(String chatId) async* {
    try {
      final result = _datasource.getChatById(chatId);

      yield* result.map((snapshot) {
        if (snapshot.docs.isEmpty) return null;

        final doc = snapshot.docs.first;
        return Chat.fromJson(doc.data() as Map<String, dynamic>);
      });
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Query<Chat> queryChats() {
    try {
      return _datasource.queryChats().withConverter(
        fromFirestore: (snapshot, _) =>
            Chat.fromJson(snapshot.data() as Map<String, dynamic>),
        toFirestore: (chat, _) => chat.toJson(),
      );
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Query<ChatMessage> queryMessages(String chatId) {
    try {
      return _datasource
          .queryMessages(chatId: chatId)
          .withConverter(
            fromFirestore: (snapshot, _) =>
                ChatMessage.fromJson(snapshot.data() as Map<String, dynamic>),
            toFirestore: (msg, _) => msg.toJson(),
          );
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }
}

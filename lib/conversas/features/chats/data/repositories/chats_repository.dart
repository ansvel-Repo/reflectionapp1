import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:image_picker/image_picker.dart';

abstract class ChatsRepository {
  Future<void> sendMessage(ChatMessage message, XFile? image);
  Future<void> deleteMessage(String chatId, ChatMessage message);
  Stream<Chat?> getChatByParticipantId(String userId);
  Stream<bool> hasChatMessages(String chatId);
  Query<ChatMessage> queryMessages(String chatId);
  Stream<Chat?> getChatById(String chatId);
  Future<void> deleteChat(String chatId);
  Query<Chat> queryChats();
}

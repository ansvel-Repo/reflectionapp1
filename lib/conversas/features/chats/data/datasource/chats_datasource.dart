import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ChatsDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;
  ChatsDataSource(this._firestore, this._auth, this._storage);

  String? get _currentUserId => _auth.currentUser?.uid;

  Future<void> sendMessage(ChatMessage message, XFile? image) async {
    if (_currentUserId != null) {
      //assign the sender id
      message = message.copyWith(senderId: _currentUserId);

      //if chatId is empty, means there is no chat created between them,
      //will be created a chat room for both
      //otherwise use the same chat to save the messages

      final chatId = message.chatId.isEmpty
          ? await _createChat(message)
          : message.chatId;

      message = message.copyWith(chatId: chatId);
      await _saveMessage(message, image);
    }
  }

  Future<String> _createChat(ChatMessage message) async {
    //set up new chat
    final newChat = Chat(
      chatId: '',
      participants: [message.receiverId, message.senderId],
      lastMessage: message.text.isNotEmpty ? message.text : '',
      createdAt: Timestamp.now(),
      lastMessageDate: Timestamp.now(),
    );

    final result = await _chatsCollectionRef().add(newChat.toJson());
    final chatId = result.id;

    await _chatsCollectionRef().doc(chatId).update({
      FirebaseFieldName.chatId: chatId,
    });

    return chatId;
  }

  Future<void> _saveMessage(ChatMessage message, XFile? image) async {
    final chatId = message.chatId;
    if (chatId.isEmpty) return;

    final result = await _messagesCollectionRef(chatId).add(message.toJson());
    final messageId = result.id;

    if (image != null) {
      final imageUrl = await _uploadImage(image, chatId, messageId);
      message = message.copyWith(imageUrl: imageUrl);
    }

    await _messagesCollectionRef(chatId).doc(messageId).update({
      FirebaseFieldName.messageId: messageId,
      FirebaseFieldName.imageUrl: message.imageUrl,
    });

    // Update the corresponding chat document's lastMessage field.
    await _chatsCollectionRef().doc(chatId).update({
      FirebaseFieldName.lastMessage: message.text,
      FirebaseFieldName.lastMessageDate: message.createdAt,
    });
  }

  Future<String> _uploadImage(XFile image, String chatId, String msgId) async {
    final file = File(image.path);
    //the file will be save on chats/chatId/messages/messageId
    final snapshot = await _chatMsgsImagesRef(
      chatId,
    ).child(msgId).putFile(file);

    return await snapshot.ref.getDownloadURL();
  }

  Stream<QuerySnapshot<Object?>> getChatByParticipantId(
    String participantId,
  ) async* {
    if (_currentUserId == null) return;

    //By providing [senderId, receiverId] & [receiverId,senderId] as the values,
    //we are querying for documents where the "participants"
    //array contains either  [senderId, receiverId] or [receiverId,senderId].
    yield* _chatsCollectionRef()
        .where(
          FirebaseFieldName.participants,
          whereIn: [
            [_currentUserId, participantId],
            [participantId, _currentUserId],
          ],
        )
        .limit(1)
        .snapshots();
  }

  Stream<QuerySnapshot<Object?>> getChatById(String chatId) async* {
    if (_currentUserId == null) return;

    yield* _chatsCollectionRef()
        .where(FirebaseFieldName.chatId, isEqualTo: chatId)
        .limit(1)
        .snapshots();
  }

  //messages query
  Query<Object?> queryMessages({required String chatId}) =>
      _messagesCollectionRef(
        chatId,
      ).orderBy(FirebaseFieldName.createdAt, descending: true);

  //chats query
  Query<Object?> queryChats() => _chatsCollectionRef()
      .where(FirebaseFieldName.participants, arrayContainsAny: [_currentUserId])
      .orderBy(FirebaseFieldName.lastMessageDate, descending: true);

  //get all user's chats
  Stream<bool> hasChatMessages(String chatId) async* {
    if (chatId.isNotEmpty) {
      yield* _messagesCollectionRef(
        chatId,
      ).snapshots().map((snapshot) => snapshot.docs.isNotEmpty);
    } else {
      yield false;
    }
  }

  //
  Future<void> deleteChat(String chatId) async {
    await _chatsCollectionRef().doc(chatId).delete();
  }

  Future<void> deleteMessage(String chatId, ChatMessage message) async {
    if (message.imageUrl.isNotEmpty) {
      await _deleteMessageImage(chatId, message.messageId);
    }
    if (chatId.isNotEmpty) {
      await _chatsCollectionRef().doc(chatId).update({
        FirebaseFieldName.lastMessage: message.text,
      });
      await _messagesCollectionRef(chatId).doc(message.messageId).delete();
    }
  }

  Future<void> _deleteMessageImage(String chatId, String messageId) async {
    final snapshot = _chatMsgsImagesRef(chatId).child(messageId);

    await snapshot.delete();
  }

  //All Collection Reference bellow
  CollectionReference _chatsCollectionRef() {
    return _firestore.collection(FirebaseCollectionName.chats);
  }

  CollectionReference _messagesCollectionRef(String chatId) {
    return _firestore
        .collection(FirebaseCollectionName.chats)
        .doc(chatId)
        .collection(FirebaseCollectionName.messages);
  }

  //save the msg img into firebase storage
  Reference _chatMsgsImagesRef(String chatId) {
    return _storage
        .ref()
        .child(FirebaseCollectionName.chats)
        .child(chatId)
        .child(FirebaseCollectionName.messages);
  }
}

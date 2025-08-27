import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class GroupDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;
  GroupDataSource(this._firestore, this._auth, this._storage);

  String? get _currentUserId => _auth.currentUser?.uid;

  Future<void> createGroup(GroupModel group, XFile? image) async {
    final groupRef = _groupsCollectionRef().doc();
    final groupId = groupRef.id;

    //assign the created group Id
    group = group.copyWith(groupId: groupId);

    if (image != null) {
      final newImageUrl = await _uploadImage(File(image.path), groupId);
      group = group.copyWith(imageUrl: newImageUrl);
    }
    await _groupsCollectionRef().doc(groupId).set(group.toJson());
  }

  Future<String> _uploadImage(File file, String groupId) async {
    final snapshot = await _imagesRef()
        .child(FirebaseCollectionName.groupsImg)
        .child(groupId)
        .putFile(file);

    return await snapshot.ref.getDownloadURL();
  }

  Stream<QuerySnapshot<Object?>> getGroupById(String groupId) async* {
    if (_currentUserId == null) return;

    yield* _groupsCollectionRef()
        .where(FieldPath.documentId, isEqualTo: groupId)
        .limit(1)
        .snapshots();
  }

  Future<void> updateGroup(GroupModel group, XFile? image) async {
    final groupId = group.groupId;
    if (image != null) {
      final newImageUrl = await _uploadImage(File(image.path), groupId);
      group = group.copyWith(imageUrl: newImageUrl);
    }

    await _groupsCollectionRef().doc(groupId).update(group.toJson());
  }

  Future<void> deleteGroup(String groupId) async {
    await _groupsCollectionRef().doc(groupId).delete();
  }

  //chats query
  Query<Object?> queryGroups() => _groupsCollectionRef()
      .where(FirebaseFieldName.membersIds, arrayContainsAny: [_currentUserId])
      .orderBy(FirebaseFieldName.lastActivity, descending: true);
  //chats query
  Query<Object?> queryMessages(String groupId) => _messagesCollectionRef(
    groupId,
  ).orderBy(FirebaseFieldName.createdAt, descending: true);

  Future<void> sendMessage(GroupMessage message, XFile? image) async {
    if (_currentUserId == null) return;
    final groupId = message.groupId;
    final msgRef = _messagesCollectionRef(groupId).doc();
    final msgId = msgRef.id;

    //assign the msg id & senderId
    message = message.copyWith(senderId: _currentUserId, messageId: msgId);

    if (image != null) {
      final imageUrl = await _uploadMsgImg(image, message);
      message = message.copyWith(imageUrl: imageUrl);
    }

    await Future.wait([
      _messagesCollectionRef(groupId).doc(msgId).set(message.toJson()),
      _groupsCollectionRef().doc(message.groupId).update({
        FirebaseFieldName.lastActivity: message.createdAt,
      }),
    ]);
  }

  Future<String> _uploadMsgImg(XFile image, GroupMessage message) async {
    final file = File(image.path);
    final snapshot = await _msgsImagesRef(
      message.groupId,
    ).child(message.messageId).putFile(file);

    return await snapshot.ref.getDownloadURL();
  }

  Stream<QuerySnapshot<Object?>> fetchLastMessage(String groupId) async* {
    CollectionReference messagesCollectionRef = _messagesCollectionRef(groupId);

    yield* messagesCollectionRef
        .orderBy(FirebaseFieldName.createdAt, descending: true)
        .limit(1)
        .snapshots();
  }

  Future<void> deleteMessage(GroupMessage message) async {
    if (message.imageUrl.isNotEmpty) {
      await _deleteMessageImage(message);
    }

    await _messagesCollectionRef(
      message.groupId,
    ).doc(message.messageId).delete();
  }

  Future<void> _deleteMessageImage(GroupMessage message) async {
    final snapshot = _msgsImagesRef(message.groupId).child(message.messageId);

    await snapshot.delete();
  }

  //save the msg img into firebase storage
  Reference _msgsImagesRef(String groupId) {
    return _storage
        .ref()
        .child(FirebaseCollectionName.groups)
        .child(groupId)
        .child(FirebaseCollectionName.messages);
  }

  CollectionReference _messagesCollectionRef(String groupId) {
    return _firestore
        .collection(FirebaseCollectionName.groups)
        .doc(groupId)
        .collection(FirebaseCollectionName.messages);
  }

  CollectionReference _groupsCollectionRef() {
    return _firestore.collection(FirebaseCollectionName.groups);
  }

  Reference _imagesRef() {
    return _storage.ref();
  }
}

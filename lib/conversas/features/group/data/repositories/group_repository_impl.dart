import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:image_picker/image_picker.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupDataSource _datasource;
  GroupRepositoryImpl(this._datasource);

  @override
  Future<void> createGroup(GroupModel group, XFile? image) async {
    try {
      await _datasource.createGroup(group, image);
    } on FirebaseException catch (e) {
      log(e.toString());
      throw '${e.message}';
    }
  }

  @override
  Query<GroupModel> queryGroups() {
    try {
      return _datasource.queryGroups().withConverter(
        fromFirestore: (snapshot, _) =>
            GroupModel.fromJson(snapshot.data() as Map<String, dynamic>),
        toFirestore: (group, _) => group.toJson(),
      );
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Stream<GroupModel?> getGroupById(String groupId) async* {
    try {
      final result = _datasource.getGroupById(groupId);

      yield* result.map((snapshot) {
        if (snapshot.docs.isEmpty) return null;
        final doc = snapshot.docs.first;
        return GroupModel.fromJson(doc.data() as Map<String, dynamic>);
      });
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Future<void> updateGroup(GroupModel group, XFile? image) async {
    try {
      await _datasource.updateGroup(group, image);
    } on FirebaseException catch (e) {
      log(e.toString());
      throw '${e.message}';
    }
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    try {
      await _datasource.deleteGroup(groupId);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Future<void> sendMessage(GroupMessage message, XFile? image) async {
    try {
      await _datasource.sendMessage(message, image);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Query<GroupMessage> queryMessages(String groupId) {
    try {
      return _datasource
          .queryMessages(groupId)
          .withConverter(
            fromFirestore: (snapshot, _) =>
                GroupMessage.fromJson(snapshot.data() as Map<String, dynamic>),
            toFirestore: (msg, _) => msg.toJson(),
          );
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Future<void> deleteMessage(GroupMessage message) async {
    try {
      await _datasource.deleteMessage(message);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Stream<GroupMessage?> fetchLastMessage(String groupId) async* {
    try {
      final result = _datasource.fetchLastMessage(groupId);

      yield* result.map((snapshot) {
        if (snapshot.docs.isEmpty) return null;
        final doc = snapshot.docs.first;
        return GroupMessage.fromJson(doc.data() as Map<String, dynamic>);
      });
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }
}

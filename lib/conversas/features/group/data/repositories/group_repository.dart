import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:image_picker/image_picker.dart';

abstract class GroupRepository {
  Future<void> createGroup(GroupModel group, XFile? image);
  Future<void> updateGroup(GroupModel group, XFile? image);
  Future<void> sendMessage(GroupMessage message, XFile? image);
  Stream<GroupMessage?> fetchLastMessage(String groupId);
  Future<void> deleteMessage(GroupMessage message);
  Query<GroupMessage> queryMessages(String groupId);
  Stream<GroupModel?> getGroupById(String groupId);
  Future<void> deleteGroup(String groupId);
  Query<GroupModel> queryGroups();
}

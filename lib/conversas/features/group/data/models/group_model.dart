import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:ansvel/conversas/common/common.dart';

class GroupModel extends Equatable {
  final String groupId;
  final List<String> adminsIds;
  final String name;
  final String groupCreator;
  final String imageUrl;
  final String about;
  final List<String> membersIds;
  final Timestamp createdAt;
  final Timestamp lastActivity;
  const GroupModel({
    required this.groupId,
    required this.adminsIds,
    required this.name,
    required this.imageUrl,
    required this.about,
    required this.groupCreator,
    required this.membersIds,
    required this.createdAt,
    required this.lastActivity,
  });

  @override
  List<Object> get props {
    return [
      groupId,
      adminsIds,
      name,
      imageUrl,
      about,
      membersIds,
      createdAt,
      groupCreator,
    ];
  }

  @override
  bool get stringify => true;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      FirebaseFieldName.groupId: groupId,
      FirebaseFieldName.adminsIds: adminsIds,
      FirebaseFieldName.name: name,
      FirebaseFieldName.imageUrl: imageUrl,
      FirebaseFieldName.about: about,
      FirebaseFieldName.membersIds: membersIds,
      FirebaseFieldName.createdAt: createdAt,
      FirebaseFieldName.lastActivity: lastActivity,
      FirebaseFieldName.groupCreator: groupCreator,
    };
  }

  factory GroupModel.fromJson(Map<String, dynamic> map) {
    return GroupModel(
      groupId: map[FirebaseFieldName.groupId] ?? '',
      adminsIds: List<String>.from((map[FirebaseFieldName.adminsIds] ?? [])),
      name: map[FirebaseFieldName.name] ?? '',
      groupCreator: map[FirebaseFieldName.groupCreator] ?? '',
      imageUrl: map[FirebaseFieldName.imageUrl] ?? '',
      about: map[FirebaseFieldName.about] ?? '',
      membersIds: List<String>.from((map[FirebaseFieldName.membersIds] ?? [])),
      createdAt: map[FirebaseFieldName.createdAt] ?? Timestamp.now(),
      lastActivity: map[FirebaseFieldName.lastActivity] ?? Timestamp.now(),
    );
  }

  GroupModel copyWith({
    String? groupId,
    List<String>? adminsIds,
    String? name,
    String? groupCreator,
    String? imageUrl,
    String? about,
    List<String>? membersIds,
    Timestamp? createdAt,
    Timestamp? lastActivity,
  }) {
    return GroupModel(
      groupId: groupId ?? this.groupId,
      adminsIds: adminsIds ?? this.adminsIds,
      name: name ?? this.name,
      groupCreator: groupCreator ?? this.groupCreator,
      imageUrl: imageUrl ?? this.imageUrl,
      about: about ?? this.about,
      membersIds: membersIds ?? this.membersIds,
      createdAt: createdAt ?? this.createdAt,
      lastActivity: lastActivity ?? this.lastActivity,
    );
  }
}

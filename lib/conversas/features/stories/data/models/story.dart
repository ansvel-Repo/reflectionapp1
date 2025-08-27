import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:ansvel/conversas/common/common.dart';

class Story extends Equatable {
  final String storyId;
  final String userId;
  final String contentUrl;
  final List<String> viewedBy;
  final Timestamp expirationDate;
  final Timestamp createdAt;

  const Story({
    required this.storyId,
    required this.userId,
    required this.contentUrl,
    required this.viewedBy,
    required this.expirationDate,
    required this.createdAt,
  });

  @override
  List<Object> get props {
    return [storyId, userId, contentUrl, viewedBy, expirationDate, createdAt];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      FirebaseFieldName.storyId: storyId,
      FirebaseFieldName.userId: userId,
      FirebaseFieldName.contentUrl: contentUrl,
      FirebaseFieldName.viewedBy: viewedBy,
      FirebaseFieldName.expirationDate: expirationDate,
      FirebaseFieldName.createdAt: createdAt,
    };
  }

  factory Story.fromJson(Map<String, dynamic> map) {
    return Story(
      storyId: map[FirebaseFieldName.storyId] as String,
      userId: map[FirebaseFieldName.userId] as String,
      contentUrl: map[FirebaseFieldName.contentUrl] as String,
      viewedBy: List<String>.from((map[FirebaseFieldName.viewedBy] ?? [])),
      expirationDate: map[FirebaseFieldName.expirationDate] ?? Timestamp.now(),
      createdAt: map[FirebaseFieldName.createdAt] ?? Timestamp.now(),
    );
  }

  Story copyWith({
    String? storyId,
    String? userId,
    String? contentUrl,
    String? caption,
    List<String>? viewedBy,
    Timestamp? expirationDate,
    Timestamp? createdAt,
  }) {
    return Story(
      storyId: storyId ?? this.storyId,
      userId: userId ?? this.userId,
      contentUrl: contentUrl ?? this.contentUrl,
      viewedBy: viewedBy ?? this.viewedBy,
      expirationDate: expirationDate ?? this.expirationDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

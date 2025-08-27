import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:ansvel/conversas/common/common.dart';
import 'package:equatable/equatable.dart';

@immutable
class AppUser extends Equatable {
  final String userId;
  final String username;
  final String email;
  final String imageUrl;
  final String pushToken;
  final String about;
  final bool isOnline;
  final Timestamp lastActive;
  final Timestamp createdAt;

  const AppUser({
    required this.userId,
    required this.username,
    required this.email,
    required this.imageUrl,
    required this.pushToken,
    required this.createdAt,
    required this.isOnline,
    required this.lastActive,
    required this.about,
  });

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [userId, username, email];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      FirebaseFieldName.userId: userId,
      FirebaseFieldName.username: username,
      FirebaseFieldName.email: email,
      FirebaseFieldName.imageUrl: imageUrl,
      FirebaseFieldName.createdAt: createdAt,
      FirebaseFieldName.isOnline: isOnline,
      FirebaseFieldName.lastActive: lastActive,
      FirebaseFieldName.pushToken: pushToken,
      FirebaseFieldName.about: about,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> map) {
    return AppUser(
      userId: map[FirebaseFieldName.userId] ?? '',
      username: map[FirebaseFieldName.username] ?? '',
      email: map[FirebaseFieldName.email] ?? '',
      imageUrl: map[FirebaseFieldName.imageUrl] ?? '',
      about: map[FirebaseFieldName.about] ?? '',
      pushToken: map[FirebaseFieldName.pushToken] ?? '',
      isOnline: map[FirebaseFieldName.isOnline] ?? false,
      createdAt: map[FirebaseFieldName.createdAt] ?? Timestamp.now(),
      lastActive: map[FirebaseFieldName.lastActive] ?? Timestamp.now(),
    );
  }

  AppUser copyWith({
    String? userId,
    String? username,
    String? email,
    String? imageUrl,
    String? pushToken,
    String? about,
    bool? isOnline,
    Timestamp? lastActive,
    Timestamp? createdAt,
  }) {
    return AppUser(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      pushToken: pushToken ?? this.pushToken,
      about: about ?? this.about,
      isOnline: isOnline ?? this.isOnline,
      lastActive: lastActive ?? this.lastActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  ///to cache user data into shared prefs
  Map<String, dynamic> toJsonPrefs() {
    return <String, dynamic>{
      FirebaseFieldName.userId: userId,
      FirebaseFieldName.username: username,
      FirebaseFieldName.email: email,
      FirebaseFieldName.imageUrl: imageUrl,
      FirebaseFieldName.createdAt: createdAt.millisecondsSinceEpoch,
      FirebaseFieldName.isOnline: isOnline,
      FirebaseFieldName.lastActive: lastActive.millisecondsSinceEpoch,
      FirebaseFieldName.pushToken: pushToken,
      FirebaseFieldName.about: about,
    };
  }

  factory AppUser.fromJsonPrefs(Map<String, dynamic> map) {
    return AppUser(
      userId: map[FirebaseFieldName.userId] ?? '',
      username: map[FirebaseFieldName.username] ?? '',
      email: map[FirebaseFieldName.email] ?? '',
      imageUrl: map[FirebaseFieldName.imageUrl] ?? '',
      pushToken: map[FirebaseFieldName.pushToken] ?? '',
      about: map[FirebaseFieldName.about] ?? '',
      isOnline: map[FirebaseFieldName.isOnline] ?? false,
      createdAt: Timestamp.fromMillisecondsSinceEpoch(
        map[FirebaseFieldName.createdAt] ?? 0,
      ),
      lastActive: Timestamp.fromMillisecondsSinceEpoch(
        map[FirebaseFieldName.lastActive] ?? 0,
      ),
    );
  }
}

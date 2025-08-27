import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter/material.dart' show immutable;
import 'dart:developer';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class LocalCache {
  const LocalCache._();

  static final _prefs = SharedPrefs.instance;

  static Future<bool> cacheDataLocally({
    required String storageName,
    required Map<String, dynamic> data,
  }) async {
    try {
      final encodedData = json.encode(data);
      await _prefs.setString(storageName, encodedData);
      return true;
    } on Exception catch (e) {
      log('cacheDataLocally error:${e.toString()}');
      return false;
    }
  }

  static void cacheCurrentUserId({required String? id}) async {
    if (id == null) return;

    await _prefs.setString(AppKeys.currentUserId, id);
  }

  static void cacheCurrentUser({required WidgetRef ref}) async {
    final id = getCurrentUserId();
    if (id == null) return;

    final user = await ref.read(getUserByIdProvider(id).future);

    cacheDataLocally(data: user.toJsonPrefs(), storageName: user.userId);
  }

  static String? getCurrentUserId() {
    return _prefs.getString(AppKeys.currentUserId);
  }

  static AppUser? getCurrentUser() {
    final currentUserId = getCurrentUserId();
    if (currentUserId == null) return null;

    try {
      final encodedUserData = _prefs.getString(currentUserId);
      if (encodedUserData == null) return null;

      final AppUser decodedUserData = AppUser.fromJsonPrefs(
        json.decode(encodedUserData),
      );
      return decodedUserData;
    } on Exception catch (e) {
      log('fetchCachedUser error:${e.toString()}');
      return null;
    }
  }
}

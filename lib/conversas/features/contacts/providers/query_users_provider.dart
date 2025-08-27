import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final queryUsersProvider = Provider.autoDispose<Query<AppUser>>((ref) {
  final repository = ref.watch(contactsRepositoryProvider);
  final currentUserId = ref.watch(currentUserIdProvider);
  if (currentUserId == null) {
    throw AssertionError('User can\'t be null');
  }
  return repository.queryUsers();
});

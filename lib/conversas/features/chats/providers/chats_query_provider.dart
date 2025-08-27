import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/common/common.dart';

final chatsQueryProvider = Provider.autoDispose<Query<Chat>>((ref) {
  final repository = ref.watch(chatsRepositoryProvider);
  final currentUserId = ref.watch(currentUserIdProvider);
  if (currentUserId == null) {
    throw AssertionError('User can\'t be null');
  }
  return repository.queryChats();
});

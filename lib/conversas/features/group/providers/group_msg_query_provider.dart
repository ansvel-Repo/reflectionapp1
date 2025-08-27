import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/common/common.dart';

final groupMsgQueryProvider = Provider.autoDispose
    .family<Query<GroupMessage>, String>((ref, String groupId) {
      final repository = ref.watch(groupRepositoryProvider);
      final currentUserId = ref.watch(currentUserIdProvider);
      if (currentUserId == null) {
        throw AssertionError('User can\'t be null');
      }
      return repository.queryMessages(groupId);
    });

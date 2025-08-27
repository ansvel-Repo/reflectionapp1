import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/common/common.dart';

final queryRequestsProvider = Provider.autoDispose<Query<ContactRequest>>((
  ref,
) {
  final repository = ref.read(requestsRepositoryProvider);
  final currentUserId = ref.watch(currentUserIdProvider);
  if (currentUserId == null) {
    throw AssertionError('User can\'t be null');
  }
  return repository.queryRequests();
});

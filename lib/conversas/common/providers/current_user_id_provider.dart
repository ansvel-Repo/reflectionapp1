import 'package:ansvel/conversas/features/auth/auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserIdProvider = StateProvider.autoDispose<String?>((ref) {
  final repository = ref.watch(authRepositoryProvider);

  return repository.currentUserId;
});

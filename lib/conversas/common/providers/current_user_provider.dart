import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserProvider = StateProvider.autoDispose<AppUser?>((ref) {
  final userFromServer = ref.watch(streamCurrentUserProvider).asData?.value;
  final user = LocalCache.getCurrentUser();

  return user ?? userFromServer;
});

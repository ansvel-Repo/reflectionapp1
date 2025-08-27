import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/features/features.dart';

final deleteAccountProvider = FutureProvider.autoDispose((ref) async {
  final repository = ref.watch(settingsRepositoryProvider);
  return repository.deleteAccount();
});

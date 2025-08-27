import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final logoutProvider = FutureProvider.autoDispose((ref) async {
  final repository = ref.read(settingsRepositoryProvider);

  return await repository.logout();
});

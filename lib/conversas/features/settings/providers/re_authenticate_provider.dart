import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/features/features.dart';

final reAuthenticateProvider = FutureProvider.autoDispose.family((
  ref,
  String password,
) async {
  final repository = ref.watch(settingsRepositoryProvider);
  return repository.reAuthenticateUser(password);
});

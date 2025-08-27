import 'package:ansvel/conversas/features/auth/auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final resetPasswordProvider = FutureProvider.autoDispose.family((
  ref,
  String email,
) async {
  final repository = ref.watch(authRepositoryProvider);
  return repository.resetPassword(email);
});

import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateActiveStatusProvider = FutureProvider.autoDispose.family((
  ref,
  bool isOnline,
) async {
  final repository = ref.read(contactsRepositoryProvider);

  return await repository.updateActiveStatus(isOnline);
});

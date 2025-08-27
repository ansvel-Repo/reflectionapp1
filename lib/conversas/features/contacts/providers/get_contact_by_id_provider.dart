import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getContactByIdProvider = FutureProvider.autoDispose.family((
  ref,
  String contactId,
) async {
  final repository = ref.read(contactsRepositoryProvider);

  return await repository.getContactById(contactId);
});

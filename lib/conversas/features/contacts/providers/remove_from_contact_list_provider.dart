import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final removeFromContactsListProvider = FutureProvider.autoDispose.family((
  ref,
  Contact contact,
) async {
  final repository = ref.read(contactsRepositoryProvider);

  return await repository.removeContact(contact);
});

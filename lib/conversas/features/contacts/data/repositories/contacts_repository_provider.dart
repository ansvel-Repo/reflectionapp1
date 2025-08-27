import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contactsRepositoryProvider = Provider<ContactsRepository>((ref) {
  final dataSource = ref.read(contactsDatasourceProvider);
  return ContactsRepositoryImpl(dataSource);
});

import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contactsDatasourceProvider = Provider<ContactsDataSource>((ref) {
  final auth = ref.read(firebaseAuthProvider);
  final firestore = ref.read(firebaseFirestoreProvider);

  return ContactsDataSource(firestore, auth);
});

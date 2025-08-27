import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupDatasourceProvider = Provider<GroupDataSource>((ref) {
  final firestore = ref.read(firebaseFirestoreProvider);
  final storage = ref.read(firebaseStorageProvider);
  final auth = ref.read(firebaseAuthProvider);
  return GroupDataSource(firestore, auth, storage);
});

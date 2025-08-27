import 'package:ansvel/conversas/common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/features/features.dart';

final storiesDatasourceProvider = Provider<StoriesDatasource>((ref) {
  final auth = ref.read(firebaseAuthProvider);
  final firestore = ref.read(firebaseFirestoreProvider);
  final storage = ref.read(firebaseStorageProvider);
  return StoriesDatasource(firestore, auth, storage);
});

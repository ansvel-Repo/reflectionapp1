import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authDatasourceProvider = Provider<AuthDataSource>((ref) {
  final auth = ref.read(firebaseAuthProvider);
  final firestore = ref.read(firebaseFirestoreProvider);
  final storage = ref.read(firebaseStorageProvider);
  final fmc = ref.read(firebaseMessagingProvider);
  return AuthDataSource(auth, firestore, storage, fmc);
});

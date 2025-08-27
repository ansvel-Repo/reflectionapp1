import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsDatasourceProvider = Provider<SettingsDataSource>((ref) {
  final auth = ref.read(firebaseAuthProvider);
  final firestore = ref.read(firebaseFirestoreProvider);
  final storage = ref.read(firebaseStorageProvider);
  return SettingsDataSource(auth, firestore, storage);
});

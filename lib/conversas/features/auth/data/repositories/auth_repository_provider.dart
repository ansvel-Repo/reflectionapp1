import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authDataSource = ref.read(authDatasourceProvider);
  return AuthRepositoryImpl(authDataSource);
});

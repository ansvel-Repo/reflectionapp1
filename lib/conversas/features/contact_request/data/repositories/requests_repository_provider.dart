import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final requestsRepositoryProvider = Provider<RequestsRepository>((ref) {
  final dataSource = ref.read(requestsDatasourceProvider);
  return RequestsRepositoryImpl(dataSource);
});

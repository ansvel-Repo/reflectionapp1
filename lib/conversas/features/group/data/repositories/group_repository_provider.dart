import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  final dataSource = ref.read(groupDatasourceProvider);
  return GroupRepositoryImpl(dataSource);
});

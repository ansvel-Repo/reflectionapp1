import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteGroupProvider = FutureProvider.autoDispose.family((
  ref,
  String groupId,
) async {
  final repository = ref.read(groupRepositoryProvider);

  return await repository.deleteGroup(groupId);
});

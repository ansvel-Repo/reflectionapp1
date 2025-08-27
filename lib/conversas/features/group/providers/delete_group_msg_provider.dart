import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/features/features.dart';

final deleteGroupMsgProvider = FutureProvider.autoDispose.family((
  ref,
  GroupMessage msg,
) async {
  final repository = ref.read(groupRepositoryProvider);

  return await repository.deleteMessage(msg);
});

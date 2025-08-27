import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateGroupInfoProvider = FutureProvider.autoDispose.family((
  ref,
  GroupModel group,
) {
  final repository = ref.read(groupRepositoryProvider);
  final image = ref.watch(selectedImageProvider);
  return repository.updateGroup(group, image);
});

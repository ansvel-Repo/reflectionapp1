import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final createGroupProvider = StateNotifierProvider<CreateGroupNotifier, void>((
  ref,
) {
  final repository = ref.watch(groupRepositoryProvider);

  return CreateGroupNotifier(repository);
});

class CreateGroupNotifier extends StateNotifier<bool> {
  CreateGroupNotifier(this._repository) : super(false);

  final GroupRepository _repository;

  Future<void> createGroup(GroupModel group, XFile? image) async {
    await _repository.createGroup(group, image);
  }
}

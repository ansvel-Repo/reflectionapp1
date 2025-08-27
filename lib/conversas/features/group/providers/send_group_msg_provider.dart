import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final sendGroupMsgProvider = StateNotifierProvider<GroupMsgNotifier, bool>((
  ref,
) {
  final repository = ref.read(groupRepositoryProvider);

  return GroupMsgNotifier(repository);
});

//Families have no built-in support for passing multiple values to a provider
//so we will use StateNotifier to overcome this situation
class GroupMsgNotifier extends StateNotifier<bool> {
  GroupMsgNotifier(this._repository) : super(false);

  final GroupRepository _repository;

  Future<void> sendMessage(GroupMessage message, XFile? image) async {
    await _repository.sendMessage(message, image).then((value) {
      state = true;
    });
  }
}

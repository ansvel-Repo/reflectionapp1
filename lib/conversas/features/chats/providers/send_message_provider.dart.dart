import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final sendMessageProvider = StateNotifierProvider<MessageNotifier, bool>((ref) {
  final repository = ref.read(chatsRepositoryProvider);

  return MessageNotifier(repository);
});

//Families have no built-in support for passing multiple values to a provider
//so we will use StateNotifier to overcome this situation
class MessageNotifier extends StateNotifier<bool> {
  MessageNotifier(this._repository) : super(false);

  final ChatsRepository _repository;

  Future<void> sendMessage(ChatMessage message, XFile? image) async {
    await _repository.sendMessage(message, image).then((value) {
      state = true;
    });
  }
}

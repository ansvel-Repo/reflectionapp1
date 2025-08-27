import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/features/features.dart';

final deleteMessageProvider =
    StateNotifierProvider<DeleteMessageNotifier, bool>((ref) {
      final repository = ref.read(chatsRepositoryProvider);

      return DeleteMessageNotifier(repository);
    });

//Families have no built-in support for passing multiple values to a provider
//so we will use StateNotifier to overcome this situation
class DeleteMessageNotifier extends StateNotifier<bool> {
  DeleteMessageNotifier(this._repository) : super(false);

  final ChatsRepository _repository;

  Future<void> deleteMessage(Chat chat, ChatMessage message) async {
    await _repository.deleteMessage(chat.chatId, message).then((value) {
      state = true;
    });
  }
}

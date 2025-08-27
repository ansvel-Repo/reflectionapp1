import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteChatProvider = FutureProvider.autoDispose.family((
  ref,
  String chatId,
) async {
  final repository = ref.read(chatsRepositoryProvider);

  return await repository.deleteChat(chatId);
});

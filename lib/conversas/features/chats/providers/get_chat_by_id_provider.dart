import 'dart:async';

import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getChatByIdProvider = StreamProvider.family.autoDispose<Chat, String>((
  ref,
  String chatId,
) {
  final controller = StreamController<Chat>();
  final repository = ref.read(chatsRepositoryProvider);

  final sub = repository.getChatById(chatId).listen((chat) {
    if (chat != null) {
      return controller.sink.add(chat);
    }
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});

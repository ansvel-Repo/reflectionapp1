import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

final hasChatMessagesProvider = StreamProvider.family.autoDispose<bool, String>(
  (ref, String chatId) {
    final controller = StreamController<bool>();
    final repository = ref.read(chatsRepositoryProvider);

    final sub = repository.hasChatMessages(chatId).listen((hasMsg) {
      return controller.sink.add(hasMsg);
    });

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);

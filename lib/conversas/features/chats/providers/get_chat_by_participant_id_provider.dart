import 'dart:async';

import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getChatByParticipantIdProvider = StreamProvider.family
    .autoDispose<Chat?, String>((ref, String userId) {
      final controller = StreamController<Chat?>();
      final repository = ref.read(chatsRepositoryProvider);

      //this ensuring that UI doesn't attempt to render
      //data before it's available and provide a better user experience.
      controller.onListen = () {
        controller.sink.add(null);
      };

      final sub = repository.getChatByParticipantId(userId).listen((chat) {
        return controller.sink.add(chat);
      });

      ref.onDispose(() {
        sub.cancel();
        controller.close();
      });

      return controller.stream;
    });

import 'dart:async';

import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fetchLastMsgProvider = StreamProvider.family
    .autoDispose<GroupMessage?, String>((ref, String groupId) {
      final controller = StreamController<GroupMessage?>();
      final repository = ref.read(groupRepositoryProvider);

      final sub = repository.fetchLastMessage(groupId).listen((lastMessage) {
        return controller.sink.add(lastMessage);
      });

      ref.onDispose(() {
        sub.cancel();
        controller.close();
      });

      return controller.stream;
    });

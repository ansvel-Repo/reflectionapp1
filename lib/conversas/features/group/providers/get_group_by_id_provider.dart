import 'dart:async';

import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getGroupByIdProvider = StreamProvider.family
    .autoDispose<GroupModel, String>((ref, String groupId) {
      final controller = StreamController<GroupModel>();
      final repository = ref.read(groupRepositoryProvider);

      final sub = repository.getGroupById(groupId).listen((group) {
        if (group != null) {
          return controller.sink.add(group);
        }
      });

      ref.onDispose(() {
        sub.cancel();
        controller.close();
      });

      return controller.stream;
    });

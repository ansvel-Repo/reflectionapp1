import 'dart:async';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isUserMyContactProvider = StreamProvider.family.autoDispose<bool, String>(
  (ref, String userId) {
    final repository = ref.read(requestsRepositoryProvider);
    final controller = StreamController<bool>();

    final sub = repository.isUserMyContact(userId).listen((isMyContact) {
      controller.sink.add(isMyContact);
    });

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });
    return controller.stream;
  },
);

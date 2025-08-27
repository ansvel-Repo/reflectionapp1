import 'dart:async';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isContactRequestSentProvider = StreamProvider.family
    .autoDispose<bool, String>((ref, String receiverId) {
      final repository = ref.read(requestsRepositoryProvider);
      final controller = StreamController<bool>();

      final sub = repository.isContactRequestSent(receiverId).listen((
        isRequestSent,
      ) {
        controller.sink.add(isRequestSent);
      });

      ref.onDispose(() {
        sub.cancel();
        controller.close();
      });
      return controller.stream;
    });

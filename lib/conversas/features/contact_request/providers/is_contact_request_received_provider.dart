import 'dart:async';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isContactRequestReceivedProvider = StreamProvider.family
    .autoDispose<bool, String>((ref, String receiverId) {
      final repository = ref.read(requestsRepositoryProvider);
      final controller = StreamController<bool>();

      final sub = repository.isContactRequestReceived(receiverId).listen((
        isRequestReceived,
      ) {
        controller.sink.add(isRequestReceived);
      });

      ref.onDispose(() {
        sub.cancel();
        controller.close();
      });
      return controller.stream;
    });

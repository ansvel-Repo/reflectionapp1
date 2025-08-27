import 'dart:async';

import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isUserExistsProvider = StreamProvider.autoDispose.family<bool, String>((
  ref,
  String userId,
) {
  final controller = StreamController<bool>();
  final repository = ref.read(contactsRepositoryProvider);

  final sub = repository.isUserExists(userId).listen((isUserExists) {
    return controller.sink.add(isUserExists);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});

import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

final getUserByIdProvider = StreamProvider.family.autoDispose<AppUser, String>((
  ref,
  String userId,
) {
  final controller = StreamController<AppUser>();
  final repository = ref.read(contactsRepositoryProvider);

  final sub = repository.getUserById(userId).listen((user) {
    if (user != null) {
      return controller.sink.add(user);
    }
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});

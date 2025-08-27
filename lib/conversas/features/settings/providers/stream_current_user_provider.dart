import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

final streamCurrentUserProvider = StreamProvider.autoDispose<AppUser>((ref) {
  final controller = StreamController<AppUser>();
  final repository = ref.read(settingsRepositoryProvider);

  final sub = repository.getCurrentUser().listen((user) {
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

import 'dart:async';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hasStoriesProvider = StreamProvider.family.autoDispose<bool, String>((
  ref,
  String userId,
) {
  final repository = ref.read(storiesRepositoryProvider);
  final controller = StreamController<bool>();

  final sub = repository.hasStories(userId).listen((hasStories) {
    controller.sink.add(hasStories);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
});

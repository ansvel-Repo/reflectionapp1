import 'dart:async';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final totalRequestsProvider = StreamProvider.autoDispose<int>((ref) {
  final repository = ref.read(requestsRepositoryProvider);
  final controller = StreamController<int>();

  final sub = repository.totalRequests().listen((total) {
    controller.sink.add(total);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
});

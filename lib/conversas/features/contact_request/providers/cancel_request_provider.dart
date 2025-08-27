import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cancelRequestProvider = FutureProvider.autoDispose.family((
  ref,
  String receiverId,
) async {
  final repository = ref.read(requestsRepositoryProvider);

  return await repository.cancelRequest(receiverId);
});

import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final requestContactProvider = FutureProvider.autoDispose.family((
  ref,
  ContactRequest request,
) async {
  final repository = ref.read(requestsRepositoryProvider);

  return await repository.sendContactRequest(request);
});

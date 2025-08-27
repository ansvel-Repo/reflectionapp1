import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final setStoryAsSeenProvider = FutureProvider.autoDispose.family((
  ref,
  Story story,
) async {
  final repository = ref.read(storiesRepositoryProvider);

  return await repository.addUserToStoryViewedList(story);
});

import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addStoryProvider = FutureProvider.autoDispose.family((
  ref,
  Story story,
) async {
  final repository = ref.read(storiesRepositoryProvider);
  final image = ref.watch(selectedImageProvider);

  return await repository.saveStoryContent(story, image);
});

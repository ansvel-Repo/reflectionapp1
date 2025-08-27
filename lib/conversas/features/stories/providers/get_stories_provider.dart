import 'dart:async';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getStoriesProvider = StreamProvider.autoDispose.family<Stories, String>((
  ref,
  String userId,
) {
  final controller = StreamController<Stories>();

  final repository = ref.read(storiesRepositoryProvider);

  final sub = repository.fetchUserStories(userId).listen((stories) {
    //return only stories that do not expired yet
    Stories getNotExpiredStories() {
      final Stories filteredStories = [];
      for (var story in stories) {
        final isExpirationDate = AppHelpers.isExpirationDateArrived(
          story.expirationDate,
        );
        //check if the story does not expired yet
        if (!isExpirationDate) {
          filteredStories.add(story);
        }
        //delete expired story
        if (isExpirationDate) {
          repository.deleteStory(story);
        }
      }
      return filteredStories;
    }

    return controller.sink.add(getNotExpiredStories());
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
});

import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:image_picker/image_picker.dart';

abstract class StoriesRepository {
  Future<void> saveStoryContent(Story story, XFile? image);
  Future<void> addUserToStoryViewedList(Story story);
  Stream<Stories> fetchUserStories(String userId);
  Stream<bool> hasStories(String userId);
  Future<void> deleteStory(Story story);
}

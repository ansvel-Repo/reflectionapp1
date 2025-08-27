import 'package:ansvel/conversas/common/utilities/typedefs.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';

class StoriesRepositoryImpl implements StoriesRepository {
  final StoriesDatasource _datasource;
  StoriesRepositoryImpl(this._datasource);

  @override
  Stream<Stories> fetchUserStories(String userId) async* {
    try {
      final result = _datasource.fetchUserStories(userId);
      yield* result.map((snapshot) {
        return snapshot.docs
            .map((doc) => Story.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Future<void> deleteStory(Story story) async {
    try {
      await _datasource.deleteStory(story);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Future<void> saveStoryContent(Story story, XFile? image) async {
    try {
      await _datasource.saveStoryContent(story, image);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Stream<bool> hasStories(String userId) async* {
    try {
      yield* _datasource.hasStories(userId);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Future<void> addUserToStoryViewedList(Story story) async {
    try {
      await _datasource.addUserToStoryViewedList(story);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StoriesDatasource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;
  StoriesDatasource(this._firestore, this._auth, this._storage);

  String? get _currentUserId => _auth.currentUser?.uid;

  Future<void> addUserToStoryViewedList(Story story) async {
    if (_currentUserId != null) {
      story = story.copyWith(viewedBy: [...story.viewedBy, '$_currentUserId']);

      await _storiesCollectionRef(
        story.userId,
      ).doc(story.storyId).update(story.toJson());
    }
  }

  Future<void> saveStoryContent(Story story, XFile? image) async {
    if (image != null) {
      final result = await _storiesCollectionRef(
        story.userId,
      ).add(story.toJson());

      final storyId = result.id;

      final contentUrl = await _uploadStoryContent(image, storyId);

      story = story.copyWith(contentUrl: contentUrl, storyId: storyId);

      await _storiesCollectionRef(
        story.userId,
      ).doc(result.id).update(story.toJson());
    }
  }

  Future<String> _uploadStoryContent(XFile image, String storyId) async {
    final file = File(image.path);
    final snapshot = await _userStoryContentRef(storyId).putFile(file);

    return await snapshot.ref.getDownloadURL();
  }

  Stream<bool> hasStories(String userId) async* {
    yield* _storiesCollectionRef(
      userId,
    ).snapshots().map((snapshot) => snapshot.docs.isNotEmpty);
  }

  Future<void> deleteStory(Story story) async {
    await _deleteStoryContent(story.storyId).then((value) async {
      await _storiesCollectionRef(story.userId).doc(story.storyId).delete();
    });
  }

  Future<void> _deleteStoryContent(String storyId) async {
    final snapshot = _userStoryContentRef(storyId);
    try {
      await snapshot.delete();
    } on FirebaseException catch (_) {
      return;
    }
  }

  Stream<QuerySnapshot<Object?>> fetchUserStories(String userId) async* {
    yield* _storiesCollectionRef(
      userId,
    ).orderBy(FirebaseFieldName.createdAt, descending: true).snapshots();
  }

  CollectionReference _storiesCollectionRef(String userId) {
    return _firestore
        .collection(FirebaseCollectionName.users)
        .doc(userId)
        .collection(FirebaseCollectionName.stories);
  }

  Reference _userStoryContentRef(String storyId) {
    return _storage
        .ref()
        .child(FirebaseCollectionName.stories)
        .child('$_currentUserId')
        .child(storyId);
  }
}

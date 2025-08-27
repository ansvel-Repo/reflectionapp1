import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseMessaging _fmc;
  final FirebaseStorage _storage;

  AuthDataSource(this._auth, this._firestore, this._storage, this._fmc);

  String? get currentUserId => _auth.currentUser?.uid;

  Future<void> _getCurrentUser() async {
    final result = await _usersCollectionRef()
        .where(FirebaseFieldName.userId, isEqualTo: currentUserId)
        .limit(1)
        .withConverter(
          fromFirestore: (snapshot, _) =>
              AppUser.fromJson(snapshot.data() as Map<String, dynamic>),
          toFirestore: (msg, _) => msg.toJson(),
        )
        .get();

    if (result.docs.isEmpty) return;

    _cacheUserLocally(result.docs.first.data());
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> logIn(String email, String password) async {
    final UserCredential result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final pushToken = await _getUserToken();
    final userId = result.user?.uid;

    if (userId == null) return;

    //cache user id locally
    LocalCache.cacheCurrentUserId(id: userId);

    //set users status to online
    //& token for push notifications
    await Future.wait([
      _getCurrentUser(),
      _usersCollectionRef().doc(userId).update({
        FirebaseFieldName.isOnline: true,
        FirebaseFieldName.pushToken: pushToken,
        FirebaseFieldName.lastActive: Timestamp.now(),
      }),
    ]);
  }

  Future<void> signUp(AppUser user, String password, XFile? image) async {
    final UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: user.email,
      password: password,
    );
    final pushToken = await _getUserToken();
    final userId = result.user?.uid;

    if (userId == null) return;
    //assign the created userId & token for push notifications
    user = user.copyWith(userId: userId, pushToken: pushToken);

    if (image != null) {
      final newImageUrl = await _uploadImage(File(image.path), userId);
      user = user.copyWith(imageUrl: newImageUrl);
    }

    //cache user id locally
    LocalCache.cacheCurrentUserId(id: userId);

    await Future.wait([
      _usersCollectionRef().doc(userId).set(user.toJson()).then((value) {
        _sendVerificationEmail();
      }),
      _cacheUserLocally(user),
    ]);
  }

  //get user device token for push notifications
  Future<String> _getUserToken() async {
    final fcmToken = await _fmc.getToken();
    if (fcmToken == null) return '';
    return fcmToken;
  }

  Future<String> _uploadImage(File file, String userId) async {
    final snapshot = await _imagesRef()
        .child(FirebaseCollectionName.usersImages)
        .child(userId)
        .putFile(file);

    return await snapshot.ref.getDownloadURL();
  }

  Future<bool> _isUserExists(String userId) async {
    // Check if a user document with the
    //given userId exists in the users collection
    final userDocument = await _usersCollectionRef().doc(userId).get();
    return userDocument.exists;
  }

  Future<void> _cacheUserLocally(AppUser user) async {
    //cache user locally
    await LocalCache.cacheDataLocally(
      storageName: user.userId,
      data: user.toJsonPrefs(),
    );
  }

  void _sendVerificationEmail() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }
    }
  }

  CollectionReference _usersCollectionRef() {
    return _firestore.collection(FirebaseCollectionName.users);
  }

  Reference _imagesRef() {
    return _storage.ref();
  }
}

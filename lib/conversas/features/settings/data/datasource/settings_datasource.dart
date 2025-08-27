import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SettingsDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  SettingsDataSource(this._auth, this._firestore, this._storage);

  String? get _currentUserId => _auth.currentUser?.uid;

  Future<void> logOut() async {
    await SharedPrefs.instance.clear();
    if (_currentUserId != null) {
      await _usersCollectionRef()
          .doc(_currentUserId)
          .update({
            FirebaseFieldName.isOnline: false,
            FirebaseFieldName.pushToken: '',
          })
          .then((value) async {
            await Future.wait([
              //clear all users default
              SharedPrefs.instance.clear(),
              _auth.signOut(),
            ]);
          });
    }
  }

  Stream<QuerySnapshot<Object?>> getCurrentUser() async* {
    if (_currentUserId != null) {
      yield* _usersCollectionRef()
          .where(FirebaseFieldName.userId, isEqualTo: _currentUserId)
          .limit(1)
          .snapshots();
    }
  }

  Future<void> updateUserProfile(AppUser user, XFile? image) async {
    final userId = user.userId;

    if (image != null) {
      final newImageUrl = await _uploadImage(File(image.path), userId);
      user = user.copyWith(imageUrl: newImageUrl);
    }

    await Future.wait([
      _usersCollectionRef().doc(userId).update(user.toJson()),
      //update user's cache data
      LocalCache.cacheDataLocally(
        storageName: user.userId,
        data: user.toJsonPrefs(),
      ),
    ]);
  }

  Future<String> _uploadImage(File file, String userId) async {
    final snapshot = await _imagesRef().child(userId).putFile(file);

    return await snapshot.ref.getDownloadURL();
  }

  //START - Reauthenticate
  Future<void> reAuthenticateUser(String password) async {
    final User? currentUser = _auth.currentUser;
    final credential = EmailAuthProvider.credential(
      email: '${currentUser?.email}',
      password: password,
    );
    await _auth.currentUser?.reauthenticateWithCredential(credential);
  }

  //END - Reauthenticate

  //START - DELETE ACCOUNT
  Future<void> deleteUser() async {
    //delete current user
    await Future.wait([
      //clear all users default
      SharedPrefs.instance.clear(),
      _deleteUserImage(),
      _deleteUserFormFirestore(),
    ]).then((value) async {
      await _deletePermanentlyCurrentUser();
    });
  }

  Future<void> _deleteUserImage() async {
    if (_currentUserId != null) {
      try {
        // Check if the image reference exists before attempting to delete
        final snapshot = await _imagesRef()
            .child('$_currentUserId')
            .getDownloadURL();

        // Image reference exists, proceed with deletion
        if (snapshot.isNotEmpty) {
          await _imagesRef().child('$_currentUserId').delete();
        }
      } on FirebaseException catch (_) {
        // Image reference does not exist
        return;
      }
    }
  }

  Future<void> _deleteUserFormFirestore() async {
    await _firestore
        .collection(FirebaseCollectionName.users)
        .doc(_currentUserId)
        .delete();
  }

  Future<void> _deletePermanentlyCurrentUser() async {
    if (_currentUserId != null) {
      await _auth.currentUser?.delete();
      await _auth.signOut();
    }
  }
  //END - DELETE ACCOUNT

  CollectionReference _usersCollectionRef() {
    return _firestore.collection(FirebaseCollectionName.users);
  }

  Reference _imagesRef() {
    return _storage.ref().child(FirebaseCollectionName.usersImages);
  }
}

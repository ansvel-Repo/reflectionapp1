import 'package:ansvel/conversas/features/features.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsDataSource _settingsDatasource;
  SettingsRepositoryImpl(this._settingsDatasource);

  @override
  Stream<AppUser?> getCurrentUser() async* {
    try {
      final result = _settingsDatasource.getCurrentUser();

      yield* result.map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          final doc = snapshot.docs.first;
          return AppUser.fromJson(doc.data() as Map<String, dynamic>);
        } else {
          return null;
        }
      });
    } on FirebaseAuthException catch (e) {
      '${e.message}';
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _settingsDatasource.logOut();
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Future<void> updateUserProfile(AppUser user, XFile? image) async {
    try {
      await _settingsDatasource.updateUserProfile(user, image);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Future<void> reAuthenticateUser(String password) async {
    try {
      await _settingsDatasource.reAuthenticateUser(password);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _settingsDatasource.deleteUser();
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }
}

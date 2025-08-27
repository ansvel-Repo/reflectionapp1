import 'package:ansvel/conversas/features/features.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDatasource;
  AuthRepositoryImpl(this._authDatasource);

  @override
  Future<bool> logIn(String email, String password) async {
    bool isLoggedIn = false;
    try {
      await _authDatasource.logIn(email, password).then((value) {
        isLoggedIn = true;
      });
      return isLoggedIn;
    } on FirebaseAuthException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Future<bool> signUp(AppUser user, String password, XFile? image) async {
    bool authSuccess = false;
    try {
      await _authDatasource.signUp(user, password, image).then((value) {
        authSuccess = true;
      });
      return authSuccess;
    } on FirebaseAuthException catch (e) {
      throw '${e.message}';
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _authDatasource.resetPassword(email);
    } on FirebaseException catch (e) {
      throw '${e.message}';
    }
  }


  @override
  String? get currentUserId => _authDatasource.currentUserId;
}

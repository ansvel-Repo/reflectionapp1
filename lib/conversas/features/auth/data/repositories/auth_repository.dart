import 'package:ansvel/conversas/features/features.dart';
import 'package:image_picker/image_picker.dart';

abstract class AuthRepository {
  Future<bool> logIn(String email, String password);
  Future<bool> signUp(AppUser user, String password, XFile? image);
  Future<void> resetPassword(String email);
  String? get currentUserId;
}

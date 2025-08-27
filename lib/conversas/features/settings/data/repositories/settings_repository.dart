import 'package:ansvel/conversas/features/features.dart';
import 'package:image_picker/image_picker.dart';

abstract class SettingsRepository {
  Future<void> updateUserProfile(AppUser user, XFile? image);
  Future<void> reAuthenticateUser(String password);
  Stream<AppUser?> getCurrentUser();
  Future<void> deleteAccount();
  Future<void> logout();
}

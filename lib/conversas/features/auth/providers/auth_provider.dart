import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  final repository = ref.watch(authRepositoryProvider);

  return AuthNotifier(repository);
});

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier(this._repository) : super(false);

  final AuthRepository _repository;

  Future<void> logIn(String email, String password) async {
    await _repository.logIn(email, password);
  }

  Future<void> signUp(AppUser user, String password, XFile? image) async {
    await _repository.signUp(user, password, image);
  }
}

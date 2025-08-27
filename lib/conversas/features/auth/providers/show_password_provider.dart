import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginShowPasswordProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});

final signUpShowPasswordProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});

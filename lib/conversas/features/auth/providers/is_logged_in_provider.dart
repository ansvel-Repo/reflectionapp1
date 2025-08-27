import 'package:ansvel/conversas/common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isLoggedInProvider = StateProvider.autoDispose<bool>((ref) {
  final prefs = SharedPrefs.instance;
  final bool isLoggedIn = prefs.getBool(AppKeys.isLoggedIn) ?? false;
  return isLoggedIn;
});

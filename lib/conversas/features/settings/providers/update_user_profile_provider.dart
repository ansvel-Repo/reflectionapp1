import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateUserProfileProvider = FutureProvider.autoDispose.family((
  ref,
  AppUser user,
) {
  final repository = ref.read(settingsDatasourceProvider);
  final image = ref.watch(selectedImageProvider);
  return repository.updateUserProfile(user, image);
});

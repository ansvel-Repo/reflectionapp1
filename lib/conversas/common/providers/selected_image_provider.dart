import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final selectedImageProvider = StateProvider.autoDispose<XFile?>((ref) {
  return null;
});

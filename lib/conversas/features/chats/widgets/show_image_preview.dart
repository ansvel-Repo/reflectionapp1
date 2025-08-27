import 'dart:io';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ShowImagePreview extends ConsumerWidget {
  const ShowImagePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = ref.watch(selectedImageProvider);

    return image != null
        ? Center(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: AppBorders.allMedium,
                  child: Image.file(File(image.path), fit: BoxFit.cover),
                ),
                IconButton(
                  onPressed: () {
                    ref.read(selectedImageProvider.notifier).state = null;
                  },
                  icon: const Icon(Iconsax.close_circle),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AddStoryPage extends ConsumerWidget {
  static AddStoryPage builder(BuildContext context, GoRouterState state) =>
      const AddStoryPage();
  const AddStoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = ref.watch(selectedImageProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final deviceSize = context.deviceSize;
    final l10n = context.l10n;

    return Scaffold(
      appBar: image == null ? const CommonAppBar() : null,
      body: SizedBox(
        height: deviceSize.height,
        width: deviceSize.width,
        child: image == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.outlined(
                    onPressed: () {
                      AppHelpers.getImageFromGallery(ref: ref);
                    },
                    icon: Icon(Iconsax.add, size: AppSizes.largest),
                  ),
                  AppSpaces.vSmall,
                  Text(l10n.addImage),
                ],
              )
            : Stack(
                alignment: Alignment.topRight,
                children: [
                  SizedBox(
                    height: deviceSize.height,
                    width: deviceSize.width,
                    child: Image.file(File(image.path), fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: AppSizes.topLarge,
                    left: AppSizes.leftRight,
                    child: IconButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              ref.read(selectedImageProvider.notifier).state =
                                  null;
                            },
                      icon: Icon(Iconsax.close_circle, size: AppSizes.large),
                    ),
                  ),
                  Positioned(
                    top: AppSizes.topLarge,
                    right: AppSizes.leftRight,
                    child: IconButton(
                      onPressed: () {
                        _addStory(context, ref);
                      },
                      icon: isLoading
                          ? const LoadingIndicator()
                          : Icon(Iconsax.send_1, size: AppSizes.large),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _addStory(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final userId = ref.read(currentUserIdProvider);

    if (userId != null) {
      ref.watch(isLoadingProvider.notifier).state = true;

      final expirationDate = AppHelpers.calculateStoryExpirationDate();
      final story = Story(
        storyId: '',
        userId: userId,
        contentUrl: '',
        viewedBy: const [],
        expirationDate: expirationDate,
        createdAt: Timestamp.now(),
      );

      ref
          .read(addStoryProvider(story).future)
          .then((value) {
            ref.watch(isLoadingProvider.notifier).state = false;
            context.pop();
          })
          .catchError((error) {
            ref.watch(isLoadingProvider.notifier).state = false;
            AppAlerts.displaySnackbar(l10n.somethingWentWrong);
          });
    }
  }
}

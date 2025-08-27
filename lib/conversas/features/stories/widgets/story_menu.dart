import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ansvel/conversas/config/config.dart';

class StroyMenu extends ConsumerWidget {
  const StroyMenu({
    super.key,
    this.onOpened,
    this.onCanceled,
    required this.story,
  });

  final VoidCallback? onOpened;
  final VoidCallback? onCanceled;
  final Story story;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentUserIdProvider);
    final isMyStory = currentUserId != null && currentUserId == story.userId;
    final l10n = context.l10n;
    final colors = context.colorScheme;

    return PopupMenuButton<StoryMenuItem>(
      onSelected: (item) {
        _onMenuItemSelected(item, ref, context);
        if (onCanceled != null) {
          return onCanceled!();
        }
      },
      onOpened: onOpened,
      onCanceled: onCanceled,
      offset: const Offset(0.0, 50),
      shape: RoundedRectangleBorder(borderRadius: AppBorders.allMedium),
      icon: Icon(Iconsax.more, size: AppSizes.medium),
      itemBuilder: (ctx) {
        return [
          PopupMenuItem<StoryMenuItem>(
            value: StoryMenuItem.save,
            child: Row(
              children: [
                Icon(Icons.save_alt_rounded, size: AppSizes.small),
                AppSpaces.hSmaller,
                Text(l10n.save),
              ],
            ),
          ),
          if (isMyStory) ...[
            PopupMenuItem<StoryMenuItem>(
              value: StoryMenuItem.delete,
              child: Row(
                children: [
                  Icon(
                    Iconsax.trash,
                    color: colors.error,
                    size: AppSizes.small,
                  ),
                  AppSpaces.hSmaller,
                  Text(
                    l10n.delete,
                    style: context.textStyle.bodyLarge?.copyWith(
                      color: colors.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ];
      },
    );
  }

  void _onMenuItemSelected(
    StoryMenuItem item,
    WidgetRef ref,
    BuildContext context,
  ) async {
    final l10n = context.l10n;

    //save story image to gallery
    if (item == StoryMenuItem.save) {
      final result = await AppHelpers.downloadImage(story.contentUrl);
      if (result) {
        AppAlerts.displaySnackbar(l10n.imageSavedTo);
      } else {
        AppAlerts.displaySnackbar(l10n.anErrorOccurredWhileSavingTheImage);
      }
    }

    //delete story
    if (item == StoryMenuItem.delete) {
      await ref
          .read(deleteStoryProvider(story).future)
          .then((value) {
            return;
          })
          .catchError((error) {
            if (context.mounted) context.pop();
            AppAlerts.displaySnackbar(l10n.somethingWentWrong);
          });
    }
  }
}

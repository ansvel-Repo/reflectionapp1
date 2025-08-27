import 'package:ansvel/conversas/features/auth/auth.dart';
import 'package:ansvel/conversas/features/contacts/contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';

class StoryViewerTile extends ConsumerWidget {
  const StoryViewerTile({super.key, required this.viewerId});
  final String viewerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewerAsyncValue = ref.watch(getUserByIdProvider(viewerId));

    return AsyncValueWidget<AppUser>(
      value: viewerAsyncValue,
      data: (viewer) {
        return Row(
          children: [
            DisplayImageFromUrl(
              imgUrl: viewer.imageUrl,
              isCircleAvatar: true,
              maxRadius: AppRadius.storyUserProfileImgRadius,
            ),
            AppSpaces.hSmaller,
            Expanded(
              child: DisplayUsername(
                textColor: context.colorScheme.primary,
                user: viewer,
              ),
            ),
          ],
        );
      },
    );
  }
}

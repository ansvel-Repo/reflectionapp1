import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StoryTile extends ConsumerWidget {
  const StoryTile({
    super.key,
    required this.userId,
    this.isCurrentUser = false,
  });
  final String userId;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(getUserByIdProvider(userId));
    final textStyle = context.textStyle;
    final isStorySeen = _isStorySeenByCurrentUser(ref);
    final colors = context.colorScheme;

    return AsyncValueWidget<AppUser>(
      value: userAsyncValue,
      data: (user) {
        return Column(
          children: [
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: () {
                  context.pushNamed(RouteLocation.userStories, extra: user);
                },
                borderRadius: AppBorders.allMedium,
                child: StoryBorder(
                  borderColor: isStorySeen
                      ? colors.primaryContainer
                      : colors.primary,
                  child: ProfileImgContainer(
                    child: DisplayProfileImg(
                      imageUrl: user.imageUrl,
                      username: user.username,
                    ),
                  ),
                ),
              ),
            ),
            AppSpaces.vSmallest,
            Expanded(
              child: Text(
                isCurrentUser ? context.l10n.yourStory : _getFirstName(user),
                overflow: TextOverflow.ellipsis,
                style: textStyle.labelSmall,
              ),
            ),
          ],
        );
      },
    );
  }

  String _getFirstName(AppUser user) {
    try {
      return user.username.split(" ")[0];
    } on Exception catch (_) {
      return user.username;
    }
  }

  bool _isStorySeenByCurrentUser(WidgetRef ref) {
    final currentUserId = ref.watch(currentUserIdProvider);
    // Assume all stories are seen initially
    bool isAllStoriesSeen = true;

    if (currentUserId != null) {
      //fetch all user stories
      final stories = ref.watch(getStoriesProvider(userId)).asData?.value ?? [];

      //if there is no stories
      if (stories.isEmpty) return !isAllStoriesSeen;

      //check if all stories were seen by the currentUser or not
      if (stories.isNotEmpty) {
        for (var story in stories) {
          final isSeen = story.viewedBy.contains(currentUserId);
          // if at least one story was not seen will return false
          if (!isSeen) {
            isAllStoriesSeen = false;
            // No need to continue checking, exit the loop
            break;
          }
        }
      }
    }
    return isAllStoriesSeen;
  }
}

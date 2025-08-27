import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:go_router/go_router.dart';

class ContactTile extends ConsumerWidget {
  const ContactTile({super.key, required this.contact});
  final Contact contact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(getUserByIdProvider(contact.contactId));
    final isStorySeen = _isStorySeenByCurrentUser(ref);
    final hasStories = _hasStories(ref);
    final colors = context.colorScheme;
    final l10n = context.l10n;
    final borderWidth = hasStories
        ? isStorySeen
              ? 0
              : 2
        : 0;
    final borderColor = hasStories
        ? isStorySeen
              ? Colors.transparent
              : colors.primary
        : Colors.transparent;
    final shouldSeeContactStories = hasStories && !isStorySeen;

    return AsyncValueWidget<AppUser>(
      value: userAsyncValue,
      data: (user) {
        return Row(
          children: [
            InkWell(
              onTap: shouldSeeContactStories
                  ? () {
                      context.pushNamed(RouteLocation.userStories, extra: user);
                    }
                  : null,
              borderRadius: AppBorders.allMedium,
              child: StoryBorder(
                borderWidth: borderWidth.toDouble(),
                borderColor: borderColor,
                child: ProfileImgContainer(
                  child: DisplayProfileImg(
                    imageUrl: user.imageUrl,
                    username: user.username,
                  ),
                ),
              ),
            ),
            AppSpaces.hSmall,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DisplayUsername(user: user),
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    user.about.isEmpty ? l10n.aboutMessage : user.about,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  bool _hasStories(WidgetRef ref) {
    return ref.watch(hasStoriesProvider(contact.contactId)).asData?.value ??
        false;
  }

  bool _isStorySeenByCurrentUser(WidgetRef ref) {
    final currentUserId = ref.watch(currentUserIdProvider);
    // Assume all stories are seen initially
    bool isAllStoriesSeen = true;

    if (currentUserId != null) {
      //fetch all user stories
      final stories =
          ref.watch(getStoriesProvider(contact.contactId)).asData?.value ?? [];

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

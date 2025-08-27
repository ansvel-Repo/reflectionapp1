import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/auth/auth.dart';
import 'package:ansvel/conversas/features/stories/stories.dart';
import 'package:flutter/material.dart';

class StoryUserInfoHeader extends StatelessWidget {
  const StoryUserInfoHeader({
    super.key,
    required this.user,
    required this.story,
  });
  final AppUser user;
  final Story story;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.storyUserName,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DisplayImageFromUrl(
            imgUrl: user.imageUrl,
            isCircleAvatar: true,
            maxRadius: AppRadius.storyUserProfileImgRadius,
          ),
          AppSpaces.hSmaller,
          Expanded(
            child: DisplayUsername(
              textColor: context.colorScheme.primary,
              user: user,
            ),
          ),
          AppSpaces.hSmallest,
          DisplayTimeAgo(time: story.createdAt),
          const Spacer(),
        ],
      ),
    );
  }
}

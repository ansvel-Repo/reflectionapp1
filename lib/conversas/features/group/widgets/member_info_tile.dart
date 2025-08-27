import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisplayMemberTile extends ConsumerWidget {
  const DisplayMemberTile({
    super.key,
    required this.memberId,
    required this.group,
  });
  final String memberId;
  final GroupModel group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentUserIdProvider);
    final asyncUser = ref.watch(getUserByIdProvider(memberId));
    final isMe = currentUserId == memberId;
    final l10n = context.l10n;

    return AsyncValueWidget<AppUser>(
      value: asyncUser,
      data: (user) {
        final bool isAdmin = group.adminsIds.contains(user.userId);

        return Padding(
          padding: AppPaddings.allSmallest,
          child: Row(
            children: [
              ProfileImgContainer(
                child: DisplayProfileImg(
                  imageUrl: user.imageUrl,
                  username: user.username,
                ),
              ),
              AppSpaces.hSmall,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isMe
                        ? Text(
                            l10n.you,
                            style: context.textStyle.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : DisplayUsername(user: user),
                    Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      user.about.isEmpty ? l10n.aboutMessage : user.about,
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: isAdmin,
                child: Text(
                  l10n.admin,
                  style: context.textStyle.titleSmall?.copyWith(
                    color: context.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

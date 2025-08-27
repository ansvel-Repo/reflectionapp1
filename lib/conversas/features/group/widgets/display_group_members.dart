import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class DisplayGroupMembers extends ConsumerWidget {
  const DisplayGroupMembers({
    super.key,
    required this.group,
    required this.isCurrentUserAdmin,
  });
  final GroupModel group;
  final bool isCurrentUserAdmin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersIds = group.membersIds;
    final currentUserId = ref.watch(currentUserIdProvider);
    final isLimitReached = membersIds.length == AppConstants.groupSize;
    final textStyle = context.textStyle;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.participantsPlural(group.membersIds.length),
          style: textStyle.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        AppSpaces.vSmall,
        CustomContainer(
          child: isLimitReached
              ? Text(
                  l10n.reachedGroupMemberLimit,
                  style: textStyle.titleMedium?.copyWith(
                    color: context.colorScheme.primary,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isCurrentUserAdmin) ...[
                      TextButton.icon(
                        onPressed: () {
                          _contactAlreadyInGroup(ref, currentUserId);
                          context.push(RouteLocation.addParticipants);
                        },
                        icon: const Icon(Iconsax.add_circle),
                        label: Text(
                          l10n.addParticipants,
                          style: textStyle.titleMedium?.copyWith(
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ),
                      const Divider(),
                    ],
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        final memberId = membersIds[index];
                        final isMe = currentUserId == memberId;

                        return InkWell(
                          key: UniqueKey(),
                          onTap: isMe
                              ? null
                              : () async {
                                  await showModalBottomSheet(
                                    context: context,
                                    useSafeArea: true,
                                    useRootNavigator: true,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return GroupMemberActionsSheet(
                                        isCurrentUserAdmin: isCurrentUserAdmin,
                                        memberId: memberId,
                                        group: group,
                                      );
                                    },
                                  );
                                },
                          child: DisplayMemberTile(
                            key: UniqueKey(),
                            memberId: memberId,
                            group: group,
                          ),
                        );
                      },
                      separatorBuilder: (ctx, index) => const Divider(),
                      itemCount: membersIds.length,
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  void _contactAlreadyInGroup(WidgetRef ref, String? currentUserId) {
    ref.read(groupProvider.notifier).state = group;
    ref.read(isNewGroupProvider.notifier).state = false;
    final contactInGroupNotifier = ref.read(selectedContactProvider.notifier);
    //reset to empty state
    contactInGroupNotifier.reset();

    //group members to list of selected group
    // members to avoid adding them again
    final contacts = group.membersIds
        .where((id) => id != currentUserId)
        .toList();
    contactInGroupNotifier.addAll(contacts);
  }
}

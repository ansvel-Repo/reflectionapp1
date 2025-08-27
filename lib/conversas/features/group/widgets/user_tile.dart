import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';

class UserTile extends ConsumerWidget {
  const UserTile({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(getUserByIdProvider(userId));
    final selectedContacts = ref.watch(selectedContactProvider);
    final isSelected = selectedContacts.contains(userId);
    final colors = context.colorScheme;
    final l10n = context.l10n;

    return AsyncValueWidget<AppUser>(
      value: userAsyncValue,
      data: (user) {
        return InkWell(
          onTap: () {
            //if selected contacts reached
            // the group members
            if (selectedContacts.length < AppConstants.groupSize) {
              _addOrRemoveContactFromList(isSelected: isSelected, ref: ref);
            } else {
              AppAlerts.displaySnackbar(l10n.reachedGroupMemberLimit);
            }
          },
          borderRadius: AppBorders.allSmall,
          child: Padding(
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
                      DisplayUsername(user: user),
                      Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        user.about.isEmpty ? l10n.aboutMessage : user.about,
                      ),
                    ],
                  ),
                ),
                AppSpaces.hSmall,
                Checkbox.adaptive(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  activeColor: colors.primary,
                  value: isSelected,
                  onChanged: (value) {
                    //if selected contacts reached
                    // the group members

                    if (selectedContacts.length < AppConstants.groupSize) {
                      _addOrRemoveContactFromList(
                        isSelected: isSelected,
                        ref: ref,
                      );
                    } else {
                      AppAlerts.displaySnackbar(l10n.reachedGroupMemberLimit);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addOrRemoveContactFromList({
    required bool isSelected,
    required WidgetRef ref,
  }) {
    final selectedContactNotifier = ref.read(selectedContactProvider.notifier);
    //add user to list of selected group members
    if (!isSelected) {
      selectedContactNotifier.addContact(userId);
    }
    //remove user to list of selected group members
    if (isSelected) {
      selectedContactNotifier.removeContact(userId);
    }
  }
}

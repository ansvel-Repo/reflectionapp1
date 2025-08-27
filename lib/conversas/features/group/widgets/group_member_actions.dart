import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class GroupMemberActionsSheet extends ConsumerWidget {
  const GroupMemberActionsSheet({
    super.key,
    required this.group,
    required this.memberId,
    required this.isCurrentUserAdmin,
  });
  final GroupModel group;
  final String memberId;
  final bool isCurrentUserAdmin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isThisMemberAdmin = group.adminsIds.contains(memberId);
    final colors = context.colorScheme;
    final textStyle = context.textStyle;
    final l10n = context.l10n;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(Iconsax.close_circle, color: colors.primary),
                ),
              ],
            ),
            Padding(
              padding: AppPaddings.allLarge,
              child: Column(
                children: [
                  ActionSheetHeader(userId: memberId),
                  AppSpaces.vMedium,
                  CustomContainer(
                    child: InkWell(
                      onTap: () {
                        context.pushNamed(
                          RouteLocation.contactDetails,
                          pathParameters: {AppKeys.userId: memberId},
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.info),
                          Icon(Iconsax.info_circle, size: AppSizes.medium),
                        ],
                      ),
                    ),
                  ),
                  if (isCurrentUserAdmin) ...[
                    AppSpaces.vMedium,
                    CustomContainer(
                      child: Column(
                        children: [
                          Visibility(
                            visible: !isThisMemberAdmin,
                            child: InkWell(
                              onTap: () {
                                AppAlerts.displayAlertDialog(
                                  context: context,
                                  title: l10n.makeGroupAdmin,
                                  content: l10n.areYouSureYouWantMakeAdminGroup,
                                  onConfirmation: () {
                                    _makeAdminGroup(
                                      context: context,
                                      group: group,
                                      ref: ref,
                                    );
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(l10n.makeGroupAdmin),
                                  Icon(Iconsax.user_tag, size: AppSizes.medium),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: isThisMemberAdmin,
                            child: InkWell(
                              onTap: () {
                                AppAlerts.displayAlertDialog(
                                  context: context,
                                  title: l10n.removeAsGroupAdmin,
                                  content: l10n.areYouSureYouWantRemoveAdmin,
                                  onConfirmation: () {
                                    _removeUserAsAdmin(
                                      context: context,
                                      group: group,
                                      ref: ref,
                                    );
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l10n.removeAsGroupAdmin,
                                    style: textStyle.titleSmall?.copyWith(
                                      color: colors.error,
                                    ),
                                  ),
                                  Icon(
                                    Iconsax.user_remove,
                                    size: AppSizes.medium,
                                    color: colors.error,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSpaces.vMedium,
                    CustomContainer(
                      child: InkWell(
                        onTap: () {
                          AppAlerts.displayAlertDialog(
                            context: context,
                            title: l10n.removeFromGroup,
                            content: l10n.areYouSureYouWantRemoveUserFromGroup,
                            onConfirmation: () {
                              _removeUserFromGroup(
                                context: context,
                                group: group,
                                ref: ref,
                              );
                            },
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.removeFromGroup,
                              style: textStyle.titleSmall?.copyWith(
                                color: colors.error,
                              ),
                            ),
                            Icon(
                              Iconsax.user_remove,
                              size: AppSizes.medium,
                              color: colors.error,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _removeUserFromGroup({
    required GroupModel group,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    final l10n = context.l10n;

    final isAdmin = group.adminsIds.contains(memberId);

    //if is admin remove from the admin list
    if (isAdmin) {
      group.adminsIds.remove(memberId);
    }

    //remove current user from group members
    group.membersIds.remove(memberId);

    context.pop();
    await ref
        .read(updateGroupInfoProvider(group).future)
        .then((value) {
          AppAlerts.displaySnackbar(l10n.userRemoveFromGroup);
          context.pop();
        })
        .catchError((error) {
          AppAlerts.displaySnackbar(l10n.somethingWentWrong);
        });
  }

  void _makeAdminGroup({
    required GroupModel group,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    final l10n = context.l10n;

    // add this member into the admin list
    group.adminsIds.add(memberId);

    context.pop();
    await ref
        .read(updateGroupInfoProvider(group).future)
        .then((value) {
          AppAlerts.displaySnackbar(l10n.userAddedAsGroupAdmin);
          context.pop();
        })
        .catchError((error) {
          AppAlerts.displaySnackbar(l10n.somethingWentWrong);
        });
  }

  void _removeUserAsAdmin({
    required GroupModel group,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    final l10n = context.l10n;

    // add this member into the admin list
    group.adminsIds.remove(memberId);

    context.pop();
    await ref
        .read(updateGroupInfoProvider(group).future)
        .then((value) {
          AppAlerts.displaySnackbar(l10n.userAddedAsGroupAdmin);
          context.pop();
        })
        .catchError((error) {
          AppAlerts.displaySnackbar(l10n.somethingWentWrong);
        });
  }
}

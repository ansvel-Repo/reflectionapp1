import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class GroupInfoPage extends ConsumerWidget {
  static GroupInfoPage builder(
    String groupId,
    BuildContext context,
    GoRouterState state,
  ) => GroupInfoPage(groupId: groupId);
  const GroupInfoPage({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupAsyncValue = ref.watch(getGroupByIdProvider(groupId));
    final textStyle = context.textStyle;
    final colors = context.colorScheme;
    final l10n = context.l10n;

    return Scaffold(
      appBar: CommonAppBar(
        title: l10n.groupInfo,
        centerTitle: true,
        fontSize: 16,
      ),
      body: AsyncValueWidget<GroupModel>(
        value: groupAsyncValue,
        data: (group) {
          final isCurrentUserAdmin = _isAdmin(group: group, ref: ref);
          final createdDate = AppHelpers.formatMonthYear(group.createdAt);

          return SizedBox(
            width: context.deviceSize.width,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AppPaddings.allLarge,
              child: Column(
                children: [
                  InkWell(
                    onTap: () =>
                        AppAlerts.showFullImageDialog(context, group.imageUrl),
                    borderRadius: AppBorders.allLarge,
                    child: group.imageUrl.isEmpty
                        ? DisplayCustomImg(
                            name: group.name,
                            isCircleAvatar: true,
                            maxRadius: AppRadius.kRadiusLarger,
                            fontSize: AppSizes.large,
                          )
                        : DisplayImageFromUrl(
                            imgUrl: group.imageUrl,
                            isCircleAvatar: true,
                            maxRadius: AppRadius.kRadiusLarger,
                          ),
                  ),
                  AppSpaces.vSmall,
                  Text(
                    group.name,
                    style: textStyle.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                  AppSpaces.vSmallest,
                  Text(group.groupId),
                  AppSpaces.vSmallest,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.people,
                        size: AppSizes.medium,
                        color: colors.primary,
                      ),
                      AppSpaces.hSmallest,
                      Text(l10n.participantsPlural(group.membersIds.length)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l10n.lastActivity),
                      AppSpaces.hSmaller,
                      DisplayTimeAgo(time: group.lastActivity),
                    ],
                  ),
                  AppSpaces.vLarge,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonOutlinedButton(
                        onPressed: () => context.pop(),
                        child: Text(l10n.sendMsg),
                      ),
                      AppSpaces.hSmall,
                      Visibility(
                        visible: isCurrentUserAdmin,
                        child: CommonOutlinedButton(
                          onPressed: () async {
                            await showModalBottomSheet(
                              context: context,
                              useSafeArea: true,
                              useRootNavigator: true,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return UpdateGroupInfo(group: group);
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Text(l10n.edit),
                              AppSpaces.hSmaller,
                              Icon(Iconsax.edit, size: AppSizes.medium),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpaces.vLarge,
                  CustomContainer(
                    alignment: Alignment.center,
                    height: AppSizes.extraLarge,
                    child: Text(
                      group.about.isEmpty ? l10n.aboutGroupMsg : group.about,
                      style: textStyle.titleMedium?.copyWith(
                        color: colors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // AppSpaces.vLarge,
                  // const DisplayBannerAd(),
                  AppSpaces.vLarge,
                  DisplayGroupMembers(
                    isCurrentUserAdmin: isCurrentUserAdmin,
                    group: group,
                  ),
                  AppSpaces.vLarge,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              '${l10n.createdBy} ${group.groupCreator}.',
                              maxLines: 1,
                            ),
                            Text('${l10n.created} $createdDate.'),
                          ],
                        ),
                      ),
                      AppSpaces.vSmall,
                      CustomContainer(
                        child: InkWell(
                          onTap: () {
                            AppAlerts.displayAlertDialog(
                              context: context,
                              title: l10n.exitGroup,
                              content: l10n.areYouSureYouWantExitGroup(
                                group.name,
                              ),
                              onConfirmation: () {
                                _exitGroup(
                                  ref: ref,
                                  context: context,
                                  group: group,
                                );
                              },
                            );
                          },
                          child: Text(
                            l10n.exitGroup,
                            style: context.textStyle.bodyLarge?.copyWith(
                              color: colors.error,
                            ),
                          ),
                        ),
                      ),
                      AppSpaces.vSmall,
                      Visibility(
                        visible: isCurrentUserAdmin,
                        child: CustomContainer(
                          child: InkWell(
                            onTap: () {
                              AppAlerts.displayAlertDialog(
                                context: context,
                                title: l10n.deleteGroup,
                                content: l10n.areYouSureYouWantDeleteGroup(
                                  group.name,
                                ),
                                onConfirmation: () {
                                  _deleteGroup(
                                    ref: ref,
                                    context: context,
                                    group: group,
                                  );
                                },
                              );
                            },
                            child: Text(
                              l10n.deleteGroup,
                              style: context.textStyle.bodyLarge?.copyWith(
                                color: colors.error,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _isAdmin({required GroupModel group, required WidgetRef ref}) {
    final currentUserId = ref.watch(currentUserIdProvider);
    if (currentUserId == null) return false;
    return group.adminsIds.contains(currentUserId);
  }

  void _deleteGroup({
    required GroupModel group,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    final l10n = context.l10n;
    context.pop();
    await ref
        .read(deleteGroupProvider(group.groupId).future)
        .then((value) {
          AppAlerts.displaySnackbar(l10n.groupDeleted);
          context.go(RouteLocation.chats);
        })
        .catchError((error) {
          AppAlerts.displaySnackbar(l10n.somethingWentWrong);
        });
  }

  void _exitGroup({
    required WidgetRef ref,
    required GroupModel group,
    required BuildContext context,
  }) async {
    final currentUserId = ref.watch(currentUserIdProvider);
    if (currentUserId == null) return;
    final l10n = context.l10n;

    final isAdmin = group.adminsIds.contains(currentUserId);

    //if is admin remove from the admin list
    if (isAdmin) {
      group.adminsIds.remove(currentUserId);
    }

    //remove current user from group
    group.membersIds.remove(currentUserId);

    context.pop();
    await ref
        .read(updateGroupInfoProvider(group).future)
        .then((value) {
          AppAlerts.displaySnackbar(l10n.exitGroupSuccess);
          context.go(RouteLocation.chats);
        })
        .catchError((error) {
          AppAlerts.displaySnackbar(l10n.somethingWentWrong);
        });
  }
}

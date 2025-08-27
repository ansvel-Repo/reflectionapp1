import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class GroupsPage extends StatelessWidget {
  static GroupsPage builder(BuildContext context, GoRouterState state) =>
      const GroupsPage();
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Consumer(
        builder: (ctx, ref, child) {
          final groupsQuery = ref.watch(groupsQueryProvider);

          return PaginatedQueryWidget<GroupModel>(
            query: groupsQuery,
            builder: (ctx, snapshot) {
              final groups = snapshot.docs;
              //
              _subscribeToTopic(groups);

              return Column(
                children: [
                  Visibility(
                    visible: groups.isEmpty,
                    child: Padding(
                      padding: AppPaddings.allLarge,
                      child: Column(
                        children: [
                          DisplayEmptyListMsg(
                            msg: l10n.thereIsNoGroupYet,
                            image: AppAssets.noChat,
                            imgHeight: AppSizes.kLargest,
                          ),
                          AppSpaces.vLarge,
                          CommonOutlinedButton(
                            onPressed: () =>
                                context.push(RouteLocation.addParticipants),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Iconsax.user_add, size: AppSizes.small),
                                AppSpaces.hSmall,
                                Text(l10n.createGroup),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: AppPaddings.allSmallest,
                    itemBuilder: (ctx, index) {
                      final group = groups[index].data();

                      return ListTile(
                        onTap: () {
                          context.pushNamed(
                            RouteLocation.groups,
                            pathParameters: {AppKeys.groupId: group.groupId},
                          );
                        },
                        contentPadding: AppPaddings.h16,
                        leading: DisplayProfileImg(
                          imageUrl: group.imageUrl,
                          username: group.name,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppBorders.allMedium,
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.name,
                              style: context.textStyle.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Consumer(
                              builder: (ctx, ref, child) {
                                final asyncMsg = ref.watch(
                                  fetchLastMsgProvider(group.groupId),
                                );

                                return AsyncValueWidget<GroupMessage?>(
                                  value: asyncMsg,
                                  data: (lastMsg) {
                                    return lastMsg == null
                                        ? Text(
                                            context.l10n.thereIsNoMessage,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        : Text(
                                            lastMsg.text.isEmpty
                                                ? context.l10n.photo
                                                : lastMsg.text,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        trailing: DisplayTimeAgo(time: group.lastActivity),
                      );
                    },
                    separatorBuilder: (ctx, index) => const Divider(),
                    itemCount: groups.length,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _subscribeToTopic(Groups groups) {
    for (var group in groups) {
      final groupId = group.data().groupId;
      PushNotificationDataSource.subscribeToTopic(groupId);
    }
  }
}

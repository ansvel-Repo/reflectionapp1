import 'package:ansvel/conversas/features/contacts/providers/get_contact_by_id_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:badges/badges.dart' as badges;
import 'package:ansvel/conversas/config/config.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ContactDetailsPage extends ConsumerWidget {
  static ContactDetailsPage builder(
    String userId,
    BuildContext context,
    GoRouterState state,
  ) => ContactDetailsPage(userId: userId);
  const ContactDetailsPage({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(getUserByIdProvider(userId));
    final textStyle = context.textStyle;
    final colors = context.colorScheme;
    final l10n = context.l10n;

    return Scaffold(
      appBar: CommonAppBar(
        title: l10n.contactInfo,
        centerTitle: true,
        fontSize: 16,
      ),
      body: AsyncValueWidget<AppUser>(
        value: userAsyncValue,
        data: (user) {
          final joinedDate = AppHelpers.formatMonthYear(user.createdAt);

          return Container(
            padding: AppPaddings.allLarge,
            width: context.deviceSize.width,
            child: Column(
              children: [
                InkWell(
                  onTap: () =>
                      AppAlerts.showFullImageDialog(context, user.imageUrl),
                  borderRadius: AppBorders.allLarge,
                  child: user.imageUrl.isEmpty
                      ? DisplayCustomImg(
                          name: user.username,
                          isCircleAvatar: true,
                          maxRadius: AppRadius.kRadiusLarger,
                          fontSize: AppSizes.large,
                        )
                      : DisplayImageFromUrl(
                          imgUrl: user.imageUrl,
                          isCircleAvatar: true,
                          maxRadius: AppRadius.kRadiusLarger,
                        ),
                ),
                AppSpaces.vSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppHelpers.formatUsername(user.username),
                      style: textStyle.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                    AppSpaces.hSmallest,
                    badges.Badge(
                      badgeContent: Icon(
                        Icons.check,
                        size: AppSizes.smallest,
                        color: colors.surface,
                      ),
                      position: badges.BadgePosition.topEnd(),
                      badgeStyle: badges.BadgeStyle(
                        shape: badges.BadgeShape.twitter,
                        badgeColor: colors.primary,
                      ),
                      badgeAnimation: const badges.BadgeAnimation.scale(),
                    ),
                  ],
                ),
                AppSpaces.vSmaller,
                Text(user.email),
                Visibility(visible: user.isOnline, child: Text(l10n.online)),
                Visibility(
                  visible: !user.isOnline,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l10n.lastSeen),
                      AppSpaces.hSmaller,
                      DisplayTimeAgo(time: user.lastActive),
                    ],
                  ),
                ),
                AppSpaces.vLarge,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonOutlinedButton(
                      onPressed: () {
                        context.pushNamed(
                          RouteLocation.personalChat,
                          pathParameters: {AppKeys.receiverId: user.userId},
                        );
                      },
                      child: Text(l10n.sendMsg),
                    ),
                    AppSpaces.hSmall,
                    CommonOutlinedButton(
                      onPressed: () {
                        AppAlerts.displayAlertDialog(
                          context: context,
                          title: l10n.removedUserFromContact,
                          content: l10n.areYouSureYouWantRemoveFromContact(
                            user.username,
                          ),
                          onConfirmation: () {
                            _deleteContacts(ref: ref, context: context);
                          },
                        );
                      },
                      child: Text(
                        l10n.deleteContact,
                        style: context.textStyle.titleSmall?.copyWith(
                          color: colors.error,
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpaces.vLarge,
                Column(
                  children: [
                    CustomContainer(
                      alignment: Alignment.center,
                      child: Text(
                        user.about.isEmpty ? l10n.aboutMessage : user.about,
                        style: textStyle.titleMedium?.copyWith(
                          color: colors.primary,
                        ),
                      ),
                    ),
                    AppSpaces.vLarge,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.calendar,
                          size: AppSizes.medium,
                          color: colors.primary,
                        ),
                        AppSpaces.hSmaller,
                        Text('${l10n.joined} $joinedDate'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _deleteContacts({
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    final l10n = context.l10n;
    final contact = await ref.watch(getContactByIdProvider(userId).future);

    if (contact == null) return;

    await ref
        .read(removeFromContactsListProvider(contact).future)
        .then((value) {
          AppAlerts.displaySnackbar(l10n.contactRemoved);
          context.go(RouteLocation.contacts);
        })
        .catchError((error) {
          AppAlerts.displaySnackbar(l10n.somethingWentWrong);
        });
  }
}

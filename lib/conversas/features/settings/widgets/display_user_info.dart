import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';

class DisplayUserInfo extends ConsumerWidget {
  const DisplayUserInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final colors = context.colorScheme;

    return user == null
        ? const SizedBox.shrink()
        : InkWell(
            onTap: () async {
              await showModalBottomSheet(
                context: context,
                useSafeArea: true,
                useRootNavigator: true,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return UpdateUserProfile(user: user);
                },
              );
            },
            borderRadius: AppBorders.allSmall,
            child: Card(
              color: colors.background,
              child: Padding(
                padding: AppPaddings.allLarge,
                child: Row(
                  children: [
                    Visibility(
                      visible: user.imageUrl.isNotEmpty,
                      child: DisplayImageFromUrl(
                        imgUrl: user.imageUrl,
                        isCircleAvatar: true,
                        maxRadius: AppSizes.large,
                      ),
                    ),
                    Visibility(
                      visible: user.imageUrl.isEmpty,
                      child: CircleAvatar(
                        backgroundColor: colors.primary,
                        maxRadius: AppRadius.kRadiusLarge,
                        child: Center(
                          child: Text(
                            AppHelpers.getFirstUsernameChar(user.username),
                            style: context.textStyle.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colors.surface,
                            ),
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
                            user.about.isEmpty
                                ? context.l10n.aboutMessage
                                : user.about,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

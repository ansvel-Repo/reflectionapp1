import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SelectedContactTile extends ConsumerWidget {
  const SelectedContactTile({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(getUserByIdProvider(userId));
    final colors = context.colorScheme;

    return AsyncValueWidget<AppUser>(
      value: userAsyncValue,
      data: (user) {
        return Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: AppPaddings.allSmaller,
                    child: user.imageUrl.isNotEmpty
                        ? DisplayImageFromUrl(
                            isCircleAvatar: true,
                            imgUrl: user.imageUrl,
                            maxRadius: AppRadius.kRadiusLarge,
                            fit: BoxFit.fill,
                          )
                        : CircleAvatar(
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
                  Positioned(
                    top: 2,
                    right: 2,
                    child: InkWell(
                      onTap: () {
                        ref
                            .read(selectedContactProvider.notifier)
                            .removeContact(userId);
                      },
                      borderRadius: AppBorders.allSmall,
                      child: Icon(Iconsax.close_circle5, color: colors.primary),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              _getFirstName(user.username),
              style: context.textStyle.labelLarge?.copyWith(
                color: colors.primary,
              ),
            ),
          ],
        );
      },
    );
  }

  String _getFirstName(String username) {
    final parts = username.split(" ");

    //if the user has only a name return it
    if (parts.length == 1) return username.capitalize;

    //if the user has 2 or more names return
    //the first char of first and second name
    if (parts.length >= 2) {
      final firstName = username.split(" ")[0].capitalize;
      return firstName;
    } else {
      return 'N/A';
    }
  }
}

import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActionSheetHeader extends ConsumerWidget {
  const ActionSheetHeader({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(getUserByIdProvider(userId));
    return AsyncValueWidget<AppUser>(
      value: userAsync,
      data: (user) {
        return Row(
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
                  Text(user.about, maxLines: 1),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalChatAppBarContent extends ConsumerWidget {
  const PersonalChatAppBarContent({
    super.key,
    required this.receiverId,
    required this.isReceiverExists,
  });
  final String receiverId;
  final bool isReceiverExists;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiverAsyncValue = ref.watch(getUserByIdProvider(receiverId));
    final l10n = context.l10n;

    return isReceiverExists
        ? AsyncValueWidget<AppUser>(
            value: receiverAsyncValue,
            data: (user) {
              return Row(
                children: [
                  InkWell(
                    onTap: () =>
                        AppAlerts.showFullImageDialog(context, user.imageUrl),
                    borderRadius: AppBorders.allLarge,
                    child: DisplayImageFromUrl(
                      imgUrl: user.imageUrl,
                      isCircleAvatar: true,
                      maxRadius: AppSizes.smaller,
                    ),
                  ),
                  AppSpaces.hSmall,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DisplayUsername(user: user, fontSize: 16),
                        Visibility(
                          visible: user.isOnline,
                          child: Text(
                            l10n.online,
                            style: context.textStyle.labelSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          )
        : Text(
            l10n.accountDeleted,
            style: context.textStyle.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          );
  }
}

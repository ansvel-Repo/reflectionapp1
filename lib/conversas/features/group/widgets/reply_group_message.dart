import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class ReplyGroupMessage extends StatelessWidget {
  const ReplyGroupMessage({
    super.key,
    this.message,
    this.onCancelReply,
    required this.currentUserId,
  });
  final GroupMessage? message;
  final VoidCallback? onCancelReply;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    final isMe = message?.senderId == currentUserId;

    final colors = context.colorScheme;
    final l10n = context.l10n;

    //if on cancel is null it's mean that we're not replying
    final isReplying = onCancelReply != null;

    //message to display
    final msgText = message?.text ?? '';
    final msgImg = message?.imageUrl ?? '';

    //if can display img preview when reply to msg

    return Container(
      padding: AppPaddings.allSmall,
      decoration: BoxDecoration(
        color: isReplying
            ? colors.surfaceVariant
            : colors.tertiary.withOpacity(0.1),
        borderRadius: isReplying
            ? BorderRadius.only(
                topLeft: AppRadius.allSmaller,
                topRight: AppRadius.allSmaller,
              )
            : AppBorders.allSmall,
      ),
      child: Row(
        children: [
          Container(
            height: AppSizes.largest,
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.only(
                topLeft: AppRadius.allLarge,
                bottomLeft: AppRadius.allLarge,
              ),
            ),
            width: 4,
          ),
          AppSpaces.hSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isMe) ...[
                  Text(
                    l10n.you,
                    style: context.textStyle.titleMedium?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                if (!isMe) ...[
                  Consumer(
                    builder: (ctx, ref, child) {
                      if (message == null) return const SizedBox.shrink();

                      final asyncUser = ref.watch(
                        getUserByIdProvider('${message?.senderId}'),
                      );
                      return AsyncValueWidget(
                        value: asyncUser,
                        data: (sender) => DisplayUsername(
                          key: Key(sender.userId),
                          user: sender,
                        ),
                      );
                    },
                  ),
                ],
                Visibility(
                  visible: msgText.isNotEmpty,
                  child: Row(
                    children: [
                      if (msgImg.isNotEmpty) ...[
                        Icon(Iconsax.camera, size: AppSizes.small),
                        AppSpaces.hSmallest,
                      ],
                      Flexible(child: Text(msgText, maxLines: 1)),
                    ],
                  ),
                ),
                Visibility(
                  visible: msgText.isEmpty && msgImg.isNotEmpty,
                  child: Row(
                    children: [
                      Icon(Iconsax.camera, size: AppSizes.small),
                      AppSpaces.hSmallest,
                      Text(l10n.photo),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: msgImg.isNotEmpty,
            child: ClipRRect(
              borderRadius: AppBorders.allSmallest,
              child: DisplayImageFromUrl(
                imgUrl: msgImg,
                imageHeight: AppSizes.replyPreviewImg,
                imageWidth: AppSizes.replyPreviewImg,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Visibility(
            visible: isReplying,
            child: IconButton(
              onPressed: onCancelReply,
              icon: const Icon(Iconsax.close_circle),
            ),
          ),
        ],
      ),
    );
  }
}

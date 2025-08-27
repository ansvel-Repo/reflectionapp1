import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class ReplyMessage extends StatelessWidget {
  const ReplyMessage({
    super.key,
    required this.senderId,
    required this.msgText,
    this.onCancelReply,
    required this.currentUserId,
    required this.msgImgUrl,
  });

  final VoidCallback? onCancelReply;
  final String? senderId;
  final String? msgText;
  final String? msgImgUrl;
  final String? currentUserId;

  @override
  Widget build(BuildContext context) {
    final isMe = senderId == currentUserId;

    final colors = context.colorScheme;
    final l10n = context.l10n;

    //if on cancel is null it's mean that we're not replying
    final isReplying = onCancelReply != null;

    final displayText = msgText ?? '';
    final imgUrl = msgImgUrl ?? '';

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
                      final asyncUser = ref.watch(
                        getUserByIdProvider('$senderId'),
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
                  visible: displayText.isNotEmpty,
                  child: Row(
                    children: [
                      if (imgUrl.isNotEmpty) ...[
                        Icon(Iconsax.camera, size: AppSizes.small),
                        AppSpaces.hSmallest,
                      ],
                      Flexible(child: Text(displayText, maxLines: 1)),
                    ],
                  ),
                ),
                Visibility(
                  visible: displayText.isEmpty && imgUrl.isNotEmpty,
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
            visible: imgUrl.isNotEmpty,
            child: ClipRRect(
              borderRadius: AppBorders.allSmallest,
              child: DisplayImageFromUrl(
                imgUrl: imgUrl,
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';

class GroupMessageBubble extends StatelessWidget {
  final GroupMessage message;

  const GroupMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final hasReplyMessage = message.replyMessage != null;
    final colors = context.colorScheme;
    final textStyle = context.textStyle;
    final deviceSize = context.deviceSize;

    return Consumer(
      builder: (ctx, ref, child) {
        final currentUserId = ref.watch(currentUserIdProvider);
        final isMe = message.senderId == currentUserId;

        return Row(
          mainAxisAlignment: isMe
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe ? colors.primaryContainer : colors.surfaceVariant,
                borderRadius: BorderRadius.only(
                  topLeft: AppBorders.bubbleRadius,
                  topRight: AppBorders.bubbleRadius,
                  bottomLeft: isMe ? AppBorders.bubbleRadius : AppBorders.zero,
                  bottomRight: isMe ? AppBorders.zero : AppBorders.bubbleRadius,
                ),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: deviceSize.width * 0.6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: hasReplyMessage,
                      child: ReplyGroupMessage(
                        key: const Key('ReplyGroupMsg'),
                        message: message.replyMessage,
                        currentUserId: '$currentUserId',
                      ),
                    ),
                    Visibility(
                      visible: message.imageUrl.isNotEmpty,
                      child: Container(
                        padding: AppPaddings.allSmallest,
                        height: AppSizes.msgImg,
                        width: deviceSize.width,
                        child: InkWell(
                          borderRadius: AppBorders.allSmall,
                          onTap: () => AppAlerts.showFullImageDialog(
                            context,
                            message.imageUrl,
                          ),
                          child: ClipRRect(
                            borderRadius: AppBorders.allSmall,
                            child: DisplayImageFromUrl(
                              imgUrl: message.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: AppPaddings.allSmall,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: message.text.isNotEmpty,
                            child: Text(
                              message.text,
                              style: textStyle.bodyLarge,
                            ),
                          ),
                          Text(
                            AppHelpers.formatMessageTime(message.createdAt),
                            style: textStyle.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

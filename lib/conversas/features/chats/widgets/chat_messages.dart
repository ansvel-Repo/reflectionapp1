import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:iconsax/iconsax.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({
    super.key,
    required this.chat,
    required this.onSwipedMessage,
    required this.scrollController,
  });
  final Chat chat;
  final ScrollController scrollController;
  final ValueChanged<ChatMessage> onSwipedMessage;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (ctx, ref, child) {
        final messageQuery = ref.watch(messagesQueryProvider(chat.chatId));

        return PaginatedQueryWidget<ChatMessage>(
          query: messageQuery,
          builder: (ctx, snapshot) {
            final messages = snapshot.docs;

            return SingleChildScrollView(
              reverse: true,
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 0,
                    margin: AppPaddings.allSmall,
                    child: Container(
                      width: 10,
                      padding: AppPaddings.allSmallest,
                      alignment: Alignment.center,
                      child: Text(AppHelpers.formatTimestamp(chat.createdAt)),
                    ),
                  ),
                  AppSpaces.vLarge,
                  ListView.separated(
                    reverse: true,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: AppPaddings.bottomLarge,
                    itemBuilder: (ctx, index) {
                      final message = messages[index].data();

                      return SwipeTo(
                        key: UniqueKey(),
                        onRightSwipe: (details) => onSwipedMessage(message),
                        child: GestureDetector(
                          key: UniqueKey(),
                          onDoubleTapDown: (tapDetails) {
                            _showPopUpMenu(
                              details: tapDetails,
                              message: message,
                              context: context,
                              ref: ref,
                            );
                          },
                          child: MessageBubble(
                            key: Key('${message.messageId}$index'),
                            message: message,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (ctx, index) => AppSpaces.vSmall,
                    itemCount: messages.length,
                  ),
                  AppSpaces.vLarger,
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showPopUpMenu({
    required TapDownDetails details,
    required ChatMessage message,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final currentUserId = ref.read(currentUserIdProvider);
    final l10n = context.l10n;
    final itemColor = context.colorScheme.error;
    final style = context.textStyle.labelLarge?.copyWith(color: itemColor);

    final position = _getTappedPosition(details, context);

    await showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem<String>(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Iconsax.copy, size: AppSizes.small),
              Text(l10n.copyMsg),
            ],
          ),
          onTap: () => _copyMessage(message, context),
        ),
        if (message.senderId == currentUserId) ...[
          PopupMenuItem<String>(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Iconsax.trash, size: AppSizes.small, color: itemColor),
                Text(l10n.delete, style: style),
              ],
            ),
            onTap: () =>
                _deleteMessage(message: message, ref: ref, context: context),
          ),
        ],
      ],
    );
  }

  void _deleteMessage({
    required ChatMessage message,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    final lastMessage = context.l10n.msgDeleted;
    message = message.copyWith(text: lastMessage);
    await ref.read(deleteMessageProvider.notifier).deleteMessage(chat, message);
  }

  RelativeRect _getTappedPosition(
    TapDownDetails details,
    BuildContext context,
  ) {
    //get the position where user tapped
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;

    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;

    final RelativeRect position = RelativeRect.fromLTRB(
      x,
      y,
      size.width,
      size.height,
    );

    return position;
  }

  //copy message to clipboard
  void _copyMessage(ChatMessage message, BuildContext context) async {
    if (message.text.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: message.text)).then((value) {
      AppAlerts.displaySnackbar(context.l10n.msgCopied);
    });
  }
}

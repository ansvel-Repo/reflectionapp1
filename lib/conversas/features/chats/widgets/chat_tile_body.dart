import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ChatTileBody extends ConsumerWidget {
  const ChatTileBody({super.key, required this.chatId});
  final String chatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatStream = ref.watch(getChatByIdProvider(chatId));

    return _hasMessages(chatId, ref)
        ? AsyncValueWidget(
            value: chatStream,
            data: (chat) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: chat.lastMessage.isEmpty,
                    child: Row(
                      children: [
                        Icon(Iconsax.camera, size: AppSizes.smaller),
                        AppSpaces.hSmallest,
                        Text(
                          context.l10n.photo,
                          style: context.textStyle.labelMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: chat.lastMessage.isNotEmpty,
                    child: Text(chat.lastMessage, maxLines: 1),
                  ),
                ],
              );
            },
          )
        : Text(context.l10n.thereIsNoMessage);
  }

  //check if there is messages in the chat,
  //to display message to user
  bool _hasMessages(String chatId, WidgetRef ref) {
    return ref.watch(hasChatMessagesProvider(chatId)).asData?.value ?? false;
  }
}

import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisplayLastMsgDate extends ConsumerWidget {
  const DisplayLastMsgDate({Key? key, required this.chatId}) : super(key: key);
  final String chatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatAsyncValue = ref.watch(getChatByIdProvider(chatId));

    return AsyncValueWidget<Chat>(
      value: chatAsyncValue,
      data: (chat) {
        return DisplayTimeAgo(time: chat.lastMessageDate);
      },
    );
  }
}

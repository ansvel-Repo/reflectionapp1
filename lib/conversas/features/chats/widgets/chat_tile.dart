import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class ChatTile extends ConsumerStatefulWidget {
  const ChatTile({super.key, required this.chat});
  final Chat chat;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatTileState();
}

class _ChatTileState extends ConsumerState<ChatTile> {
  //this id is for the other participant in the chat
  //not the current user
  String participantId = '';

  @override
  void initState() {
    _getParticipantId();
    super.initState();
  }

  void _getParticipantId() {
    final chat = widget.chat;
    try {
      final currentUserId = ref.read(currentUserIdProvider);

      participantId = chat.participants.firstWhere(
        (participantId) => participantId != currentUserId,
      );
    } on Exception catch (e) {
      log('Error Get Participant Id: ${e.toString()} chat Id : ${chat.chatId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isParticipantExists = _isParticipantExists(participantId);
    final chat = widget.chat;

    final userAsyncValue = ref.watch(getUserByIdProvider(participantId));

    return InkWell(
      onTap: () {
        context.pushNamed(
          RouteLocation.personalChat,
          pathParameters: {AppKeys.receiverId: participantId},
        );
      },
      borderRadius: AppBorders.allMedium,
      child: isParticipantExists
          ? AsyncValueWidget<AppUser>(
              value: userAsyncValue,
              data: (user) {
                return Padding(
                  padding: AppPaddings.allSmaller,
                  child: Row(
                    children: [
                      DisplayProfileImg(
                        imageUrl: user.imageUrl,
                        username: user.username,
                      ),
                      AppSpaces.hMedium,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: DisplayUsername(user: user)),
                                DisplayTimeAgo(time: chat.lastMessageDate),
                              ],
                            ),
                            ChatTileBody(chatId: chat.chatId),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : Opacity(
              opacity: 0.5,
              child: Row(
                children: [
                  ProfileImgContainer(
                    bgColor: context.colorScheme.primary,
                    child: const Center(
                      child: DisplayImageFromUrl(
                        imgUrl: '',
                        imageHeight: 40,
                        imageWidth: 40,
                      ),
                    ),
                  ),
                  AppSpaces.hMedium,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.l10n.accountDeleted,
                              style: context.textStyle.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            DisplayTimeAgo(time: chat.lastMessageDate),
                          ],
                        ),
                        ChatTileBody(chatId: chat.chatId),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  //check if the chat participant exists
  bool _isParticipantExists(String participantId) =>
      ref.watch(isUserExistsProvider(participantId)).asData?.value ?? true;
}

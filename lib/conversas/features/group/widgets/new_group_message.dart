import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NewGroupMessage extends ConsumerStatefulWidget {
  const NewGroupMessage({
    super.key,
    required this.group,
    required this.focusNode,
    required this.onCancelReply,
    required this.scrollController,
    this.replyMessage,
  });

  final GroupModel group;
  final ScrollController scrollController;
  final FocusNode focusNode;
  final GroupMessage? replyMessage;
  final VoidCallback onCancelReply;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewGroupMessageState();
}

class _NewGroupMessageState extends ConsumerState<NewGroupMessage> {
  late final TextEditingController _messageController;

  @override
  void initState() {
    //add listener for when users write something
    // update the _messageController
    _messageController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final msgToReply = widget.replyMessage;
    final image = ref.watch(selectedImageProvider);
    final currentUser = ref.watch(currentUserProvider);
    final isReplying = msgToReply != null;
    final canSendMsg = image != null || _messageController.text.isNotEmpty;
    final colors = context.colorScheme;
    final l10n = context.l10n;

    return SizedBox(
      width: context.deviceSize.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: image != null,
            child: Expanded(
              child: Padding(
                padding: AppPaddings.allSmallest,
                child: const ShowImagePreview(),
              ),
            ),
          ),
          Visibility(
            visible: isReplying,
            child: ReplyMessage(
              key: const Key('ReplyMessage'),
              senderId: msgToReply?.senderId,
              msgText: msgToReply?.text,
              msgImgUrl: msgToReply?.imageUrl,
              onCancelReply: widget.onCancelReply,
              currentUserId: currentUser?.userId,
            ),
          ),
          Padding(
            padding: AppPaddings.allLarge,
            child: Row(
              children: [
                Expanded(
                  child: CommonTextField(
                    key: const Key('GroupNewMessage'),
                    textCapitalization: TextCapitalization.sentences,
                    controller: _messageController,
                    hintText: l10n.writeMessageHere,
                    focusNode: widget.focusNode,
                    autocorrect: true,
                    maxLines: 5,
                    minLines: 1,
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppSpaces.hSmallest,
                        InkWell(
                          onTap: () {
                            AppHelpers.getImageFromGallery(
                              ref: ref,
                              imageSource: ImageSource.camera,
                            );
                          },
                          child: Icon(Iconsax.camera, color: colors.primary),
                        ),
                        AppSpaces.hSmallest,
                        InkWell(
                          onTap: () => AppHelpers.getImageFromGallery(ref: ref),
                          child: Icon(Iconsax.gallery, color: colors.primary),
                        ),
                        AppSpaces.hSmallest,
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: canSendMsg
                      ? () {
                          _sendMessage(image, currentUser);
                          widget.onCancelReply();
                        }
                      : null,
                  icon: Icon(
                    Iconsax.send_1,
                    size: AppSizes.large,
                    color: canSendMsg ? colors.primary : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          AppSpaces.vMedium,
        ],
      ),
    );
  }

  void _sendMessage(XFile? image, AppUser? sender) async {
    final l10n = context.l10n;

    //get the sender to assign to the chat
    //& get the token to send notification
    if (sender == null) return;

    final senderId = sender.userId;

    final text = _messageController.text.trim();
    final group = widget.group;

    //set up message
    final message = GroupMessage(
      groupId: group.groupId,
      replyMessage: widget.replyMessage,
      createdAt: Timestamp.now(),
      messageId: '',
      senderId: senderId,
      text: text,
      imageUrl: '',
    );

    //reset user input
    _resetUserInput();

    //
    await ref
        .read(sendGroupMsgProvider.notifier)
        .sendMessage(message, image)
        .then((value) async {
          //PushNotification message
          final msg = message.text.isEmpty ? l10n.photo : message.text;
          //sendPushNotification
          await NotificationService.sendGroupNotification(
            msg: msg,
            group: group,
            sender: sender,
          );

          return;
        })
        .catchError((error) {
          AppAlerts.displaySnackbar(l10n.somethingWentWrong);
        });
  }

  // This method is used to clear all user's input
  // in chat room
  void _resetUserInput() {
    //clear the (written msg by user) on text field
    _messageController.clear();

    //when a msg is sent jump to the very bottom
    // with some animation
    final controller = widget.scrollController;
    if (controller.hasClients) {
      controller.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }

    //clear user picked image
    ref.read(selectedImageProvider.notifier).state = null;
  }
}

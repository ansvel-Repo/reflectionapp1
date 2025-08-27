import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AddNewMessage extends ConsumerStatefulWidget {
  const AddNewMessage({
    super.key,
    required this.chat,
    required this.receiverId,
    required this.focusNode,
    required this.onCancelReply,
    required this.scrollController,
    this.replyMessage,
  });

  final String receiverId;
  final Chat? chat;
  final ScrollController scrollController;
  final FocusNode focusNode;
  final ChatMessage? replyMessage;
  final VoidCallback onCancelReply;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddNewMessageState();
}

class _AddNewMessageState extends ConsumerState<AddNewMessage> {
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
    final currentUserId = currentUser?.userId;
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
              currentUserId: currentUserId,
              msgImgUrl: msgToReply?.imageUrl,
              onCancelReply: widget.onCancelReply,
            ),
          ),
          Padding(
            padding: AppPaddings.allLarge,
            child: Row(
              children: [
                Expanded(
                  child: CommonTextField(
                    key: const Key('AddNewMessage'),
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
    //get the sender to assign to the chat
    //& get the token to send notification

    if (sender == null) return;

    final text = _messageController.text.trim();
    final chat = widget.chat;

    final receiverId = widget.receiverId;

    //set up message
    final message = ChatMessage(
      replyMessage: widget.replyMessage,
      createdAt: Timestamp.now(),
      chatId: chat != null ? chat.chatId : '',
      messageId: '',
      receiverId: receiverId,
      senderId: sender.userId,
      text: text,
      imageUrl: '',
    );

    _saveMessage(message: message, image: image, sender: sender);
  }

  void _saveMessage({
    required ChatMessage message,
    required XFile? image,
    required AppUser sender,
  }) async {
    final l10n = context.l10n;
    //fetch the user that will receive the msg
    final receiver = await ref.watch(
      getUserByIdProvider(widget.receiverId).future,
    );

    //reset user input
    _resetUserInput();

    //
    await ref
        .read(sendMessageProvider.notifier)
        .sendMessage(message, image)
        .then((value) async {
          //PushNotification message
          final msg = message.text.isEmpty ? l10n.photo : message.text;
          //sendPushNotification
          await NotificationService.sendPushNotification(
            receiverToken: receiver.pushToken,
            sender: sender,
            type: AppKeys.chat,
            msg: msg,
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

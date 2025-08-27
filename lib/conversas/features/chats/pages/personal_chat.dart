import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class PersonalChatPage extends StatefulWidget {
  static PersonalChatPage builder(
    String receiverId,
    BuildContext context,
    GoRouterState state,
  ) => PersonalChatPage(receiverId: receiverId);
  const PersonalChatPage({super.key, required this.receiverId});

  final String receiverId;

  @override
  State<StatefulWidget> createState() => _PersonalChatPageState();
}

class _PersonalChatPageState extends State<PersonalChatPage> {
  final ScrollController _scrollController = ScrollController();

  final _focusNode = FocusNode();
  ChatMessage? _replyMessage;

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final receiverId = widget.receiverId;
    final l10n = context.l10n;

    return AnnotatedRegion(
      value: FlexColorScheme.themedSystemNavigationBar(
        context,
        systemNavBarStyle: FlexSystemNavBarStyle.transparent,
      ),
      child: Consumer(
        builder: (ctx, ref, child) {
          final chatAsyncValue = ref.watch(
            getChatByParticipantIdProvider(receiverId),
          );
          final isReceiverExists = _isReceiverExists(ref);

          return AsyncValueWidget<Chat?>(
            value: chatAsyncValue,
            data: (chat) {
              return Scaffold(
                appBar: AppBar(
                  title: PersonalChatAppBarContent(
                    receiverId: receiverId,
                    isReceiverExists: isReceiverExists,
                  ),
                  centerTitle: true,
                ),
                bottomSheet: isReceiverExists
                    ? AddNewMessage(
                        key: const Key('AddNewMessage'),
                        chat: chat,
                        focusNode: _focusNode,
                        receiverId: receiverId,
                        replyMessage: _replyMessage,
                        onCancelReply: _cancelToReply,
                        scrollController: _scrollController,
                      )
                    : null,
                body: Padding(
                  padding: AppPaddings.allMedium,
                  child: chat == null
                      ? DisplayEmptyListMsg(
                          msg: l10n.thereIsNoMessageYet,
                          image: AppAssets.noMessage,
                        )
                      : chat.chatId.isEmpty
                      ? DisplayEmptyListMsg(
                          msg: l10n.thereIsNoMessageYet,
                          image: AppAssets.noMessage,
                        )
                      : ChatMessages(
                          chat: chat,
                          onSwipedMessage: _replyToMessage,
                          scrollController: _scrollController,
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _replyToMessage(ChatMessage message) {
    setState(() {
      _replyMessage = message;
      _focusNode.requestFocus();
    });
  }

  void _cancelToReply() {
    setState(() {
      _replyMessage = null;
    });
  }

  //check if the chat participant exists
  bool _isReceiverExists(WidgetRef ref) =>
      ref.watch(isUserExistsProvider(widget.receiverId)).asData?.value ?? true;
}

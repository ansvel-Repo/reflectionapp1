import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:swipe_to/swipe_to.dart';

class GroupChatPage extends StatefulWidget {
  static GroupChatPage builder(
    String groupId,
    BuildContext context,
    GoRouterState state,
  ) => GroupChatPage(groupId: groupId);
  const GroupChatPage({super.key, required this.groupId});

  final String groupId;

  @override
  State<StatefulWidget> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final ScrollController _scrollController = ScrollController();

  final _focusNode = FocusNode();
  GroupMessage? _replyMessage;

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupId = widget.groupId;
    final l10n = context.l10n;

    return AnnotatedRegion(
      value: FlexColorScheme.themedSystemNavigationBar(
        context,
        systemNavBarStyle: FlexSystemNavBarStyle.transparent,
      ),
      child: Consumer(
        builder: (ctx, ref, child) {
          final groupAsyncValue = ref.watch(getGroupByIdProvider(groupId));
          final groupMsgQuery = ref.watch(groupMsgQueryProvider(groupId));

          return AsyncValueWidget<GroupModel>(
            value: groupAsyncValue,
            data: (group) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  title: InkWell(
                    onTap: () {
                      context.pushNamed(
                        RouteLocation.groupInfo,
                        pathParameters: {AppKeys.groupId: group.groupId},
                      );
                    },
                    borderRadius: AppBorders.allSmall,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        group.imageUrl.isEmpty
                            ? DisplayCustomImg(
                                name: group.name,
                                isCircleAvatar: true,
                                maxRadius: AppRadius.kRadiusMedium,
                              )
                            : DisplayImageFromUrl(
                                imgUrl: group.imageUrl,
                                isCircleAvatar: true,
                                maxRadius: AppRadius.kRadiusMedium,
                              ),
                        AppSpaces.hSmallest,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.name,
                              maxLines: 1,
                              style: context.textStyle.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              l10n.participantsPlural(group.membersIds.length),
                              maxLines: 1,
                              style: context.textStyle.labelMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                bottomSheet: NewGroupMessage(
                  key: const Key('AddNewMessage'),
                  group: group,
                  focusNode: _focusNode,
                  replyMessage: _replyMessage,
                  onCancelReply: _cancelToReply,
                  scrollController: _scrollController,
                ),
                body: PaginatedQueryWidget<GroupMessage>(
                  query: groupMsgQuery,
                  builder: (context, snapshot) {
                    final msgs = snapshot.docs;
                    return SingleChildScrollView(
                      reverse: true,
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: AppPaddings.allMedium,
                      child: Column(
                        children: [
                          Card(
                            elevation: 0,
                            margin: AppPaddings.allSmall,
                            child: Container(
                              padding: AppPaddings.allSmallest,
                              alignment: Alignment.center,
                              child: Text(
                                AppHelpers.formatTimestamp(group.createdAt),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: msgs.isEmpty,
                            child: DisplayEmptyListMsg(
                              msg: l10n.thereIsNoChatYet,
                              image: AppAssets.noChat,
                              imgHeight: 250,
                            ),
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            reverse: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, index) {
                              final msg = msgs[index].data();

                              return SwipeTo(
                                key: UniqueKey(),
                                onRightSwipe: (details) => _replyToMessage(msg),
                                child: GestureDetector(
                                  key: UniqueKey(),
                                  onDoubleTapDown: (tapDetails) {
                                    _showPopUpMenu(
                                      details: tapDetails,
                                      message: msg,
                                      context: context,
                                      ref: ref,
                                    );
                                  },
                                  child: GroupMessageBubble(
                                    key: Key(index.toString()),
                                    message: msg,
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (ctx, index) => AppSpaces.vSmall,
                            itemCount: msgs.length,
                          ),
                          AppSpaces.vLargest,
                          AppSpaces.vLarge,
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _replyToMessage(GroupMessage message) {
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

  void _showPopUpMenu({
    required TapDownDetails details,
    required GroupMessage message,
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
            onTap: () async {
              await ref.read(deleteGroupMsgProvider(message).future);
            },
          ),
        ],
      ],
    );
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
  void _copyMessage(GroupMessage message, BuildContext context) async {
    if (message.text.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: message.text)).then((value) {
      AppAlerts.displaySnackbar(context.l10n.msgCopied);
    });
  }
}

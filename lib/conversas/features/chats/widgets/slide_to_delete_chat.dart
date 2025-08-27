import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class SlideToDeleteChat extends ConsumerWidget {
  const SlideToDeleteChat({Key? key, required this.child, required this.chat})
    : super(key: key);
  final Widget child;
  final Chat chat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colorScheme;
    final l10n = context.l10n;

    return Slidable(
      key: key,
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (value) => AppAlerts.displayAlertDialog(
              context: context,
              title: l10n.deleteChat,
              content: l10n.areYouSureYouWantDeleteChat,
              onConfirmation: () => _deleteChat(ref, context, chat),
            ),
            spacing: 0,
            backgroundColor: colors.background,
            foregroundColor: colors.primary,
            icon: Iconsax.message_remove,
            borderRadius: AppBorders.allLarge,
          ),
        ],
      ),
      child: child,
    );
  }

  void _deleteChat(WidgetRef ref, BuildContext context, Chat chat) async {
    final l10n = context.l10n;
    context.pop();
    await ref
        .read(deleteChatProvider(chat.chatId).future)
        .then((value) {
          AppAlerts.displaySnackbar(l10n.chatDeleted);
        })
        .catchError((error) {
          AppAlerts.displaySnackbar(l10n.somethingWentWrong);
        });
  }
}

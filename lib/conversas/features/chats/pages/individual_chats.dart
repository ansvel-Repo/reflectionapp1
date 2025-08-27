import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class IndividualChats extends StatelessWidget {
  static IndividualChats builder(BuildContext context, GoRouterState state) =>
      const IndividualChats();
  const IndividualChats({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: AppPaddings.allSmall,
      child: Consumer(
        builder: (ctx, ref, child) {
          final chatsQuery = ref.watch(chatsQueryProvider);

          return PaginatedQueryWidget<Chat>(
            query: chatsQuery,
            builder: (ctx, snapshot) {
              final chats = snapshot.docs;

              return Column(
                children: [
                  Visibility(
                    visible: chats.isEmpty,
                    child: Column(
                      children: [
                        DisplayEmptyListMsg(
                          msg: l10n.thereIsNoChatYet,
                          image: AppAssets.noChat,
                          imgHeight: 250,
                        ),
                        AppSpaces.vLarge,
                        CommonOutlinedButton(
                          onPressed: () =>
                              context.push(RouteLocation.addContact),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Iconsax.user_add, size: AppSizes.small),
                              AppSpaces.hSmall,
                              Text(l10n.addContact),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      final chat = chats[index].data();

                      return SlideToDeleteChat(
                        key: UniqueKey(),
                        chat: chat,
                        child: ChatTile(key: Key(chat.chatId), chat: chat),
                      );
                    },
                    separatorBuilder: (ctx, index) => const Divider(),
                    itemCount: chats.length,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ChatsPage extends StatefulWidget {
  static ChatsPage builder(BuildContext ctx, GoRouterState state) =>
      const ChatsPage();
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = context.l10n;
    final colors = context.colorScheme;

    return Scaffold(
      appBar: CommonAppBar(
        title: l10n.chats,
        actions: [
          IconButton(
            onPressed: () async {
              showModalBottomSheet(
                isScrollControlled: true,
                useRootNavigator: true,
                useSafeArea: true,
                context: context,
                builder: (context) {
                  return const NewChatSheet();
                },
              );
            },
            icon: Icon(Iconsax.message_add_15, color: colors.secondary),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const ContactsStories(),
            const Divider(),
            TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              padding: EdgeInsets.zero,
              labelPadding: EdgeInsets.zero,
              tabs: [
                Tab(icon: Text(l10n.individualChats)),
                Tab(icon: Text(l10n.groupChats)),
              ],
            ),
            const Expanded(
              child: TabBarView(children: [IndividualChats(), GroupsPage()]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

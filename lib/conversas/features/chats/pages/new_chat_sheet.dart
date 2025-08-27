import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class NewChatSheet extends ConsumerStatefulWidget {
  const NewChatSheet({super.key});

  @override
  ConsumerState<NewChatSheet> createState() => _NewChatSheetState();
}

class _NewChatSheetState extends ConsumerState<NewChatSheet> {
  final TextEditingController _queryController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colorScheme;

    return SizedBox(
      width: context.deviceSize.width,
      child: Column(
        children: [
          AppSpaces.vSmall,
          Row(
            children: [
              AppSpaces.hLarge,
              DisplayAnimatedText(
                text: l10n.newChat,
                textStyle: context.textStyle.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  Iconsax.close_circle,
                  color: context.colorScheme.primary,
                ),
              ),
            ],
          ),
          const Divider(),
          ListTile(
            leading: Icon(Iconsax.people, color: colors.primary),
            contentPadding: AppPaddings.leftMedium,
            title: Text(l10n.createGroup),
            trailing: IconButton(
              onPressed: () {
                ref.read(isNewGroupProvider.notifier).state = true;
                ref.read(selectedContactProvider.notifier).reset();
                context.pop();
                context.push(RouteLocation.addParticipants);
              },
              icon: Icon(
                Icons.keyboard_arrow_right_rounded,
                size: AppSizes.larger,
                color: colors.primary,
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: Consumer(
              builder: (ctx, ref, child) {
                final contactsQuery = ref.watch(contactsQueryProvider);

                return PaginatedQueryWidget<Contact>(
                  query: contactsQuery,
                  builder: (ctx, snapshot) {
                    //filter contacts by query
                    final contacts = AppHelpers.contactsFilteredByQuery(
                      contacts: snapshot.docs,
                      ref: ref,
                      query: _query,
                    );

                    return Padding(
                      padding: AppPaddings.allMedium,
                      child: Column(
                        children: [
                          CommonTextField(
                            controller: _queryController,
                            hintText: l10n.searchName,
                            prefixIcon: Icon(
                              Iconsax.search_normal,
                              color: colors.primary,
                            ),
                            suffixIcon: _query.isEmpty
                                ? null
                                : IconButton(
                                    onPressed: () {
                                      _queryController.clear();
                                      _updateQuery('');
                                    },
                                    icon: Icon(
                                      Iconsax.close_square,
                                      color: colors.primary,
                                    ),
                                  ),
                            onChanged: (query) {
                              if (query != null) {
                                _updateQuery(query);
                              }
                              return null;
                            },
                          ),
                          // AppSpaces.vLarge,
                          // const DisplayBannerAd(),
                          AppSpaces.vLarge,
                          Visibility(
                            visible: contacts.isEmpty,
                            child: Column(
                              children: [
                                AppSpaces.vLarge,
                                DisplayAnimatedText(
                                  text: l10n.noContactAddedYet,
                                ),
                                AppSpaces.vLarge,
                                CommonOutlinedButton(
                                  onPressed: () =>
                                      context.push(RouteLocation.addContact),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Iconsax.user_add,
                                        size: AppSizes.small,
                                      ),
                                      AppSpaces.hSmall,
                                      Text(l10n.addContact),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (ctx, index) {
                                final contact = contacts[index].data();

                                return InkWell(
                                  key: UniqueKey(),
                                  onTap: () {
                                    context.pushNamed(
                                      RouteLocation.personalChat,
                                      pathParameters: {
                                        AppKeys.receiverId: contact.contactId,
                                      },
                                    );
                                  },
                                  borderRadius: AppBorders.allSmall,
                                  child: ContactTile(
                                    key: Key(contact.contactId),
                                    contact: contact,
                                  ),
                                );
                              },
                              separatorBuilder: (ctx, index) => const Divider(),
                              itemCount: contacts.length,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(),
          Padding(padding: AppPaddings.h16, child: const InviteFriendsButton()),
          AppSpaces.vSmall,
        ],
      ),
    );
  }

  void _updateQuery(String value) {
    setState(() {
      _query = value;
    });
  }
}

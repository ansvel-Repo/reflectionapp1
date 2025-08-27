import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class AddParticipantsPage extends ConsumerStatefulWidget {
  static AddParticipantsPage builder(
    BuildContext context,
    GoRouterState state,
  ) => const AddParticipantsPage();
  const AddParticipantsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewGroupPageState();
}

class _NewGroupPageState extends ConsumerState<AddParticipantsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingProvider);
    final contactsQuery = ref.watch(contactsQueryProvider);
    final isNewGroup = ref.watch(isNewGroupProvider);
    final colors = context.colorScheme;
    final l10n = context.l10n;

    return WillPopScope(
      onWillPop: () async {
        ref.read(selectedContactProvider.notifier).reset();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: CommonAppBar(
          title: l10n.addParticipants,
          centerTitle: true,
          fontSize: 18,
          actions: [
            Visibility(
              visible: isNewGroup,
              child: TextButton(
                onPressed: () {
                  context.push(RouteLocation.createGroup);
                },
                child: Text(
                  l10n.next,
                  style: context.textStyle.titleMedium?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !isNewGroup,
              child: TextButton(
                onPressed: _updateParticipants,
                child: isLoading
                    ? const LoadingIndicator()
                    : Text(
                        l10n.update,
                        style: context.textStyle.titleMedium?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            AppSpaces.hSmallest,
          ],
        ),
        body: PaginatedQueryWidget<Contact>(
          query: contactsQuery,
          builder: (ctx, snapshot) {
            final allContacts = snapshot.docs;
            final contacts = AppHelpers.contactsFilteredByQuery(
              contacts: allContacts,
              ref: ref,
              query: _query,
            );

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AppPaddings.allLarge,
              child: Column(
                children: [
                  CommonTextField(
                    controller: _searchController,
                    hintText: l10n.searchName,
                    prefixIcon: Icon(
                      Iconsax.search_normal,
                      color: colors.primary,
                    ),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchController.clear();
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
                  const DisplaySelectedContacts(),
                  // AppSpaces.vLarge,
                  // const DisplayBannerAd(),
                  AppSpaces.vLarge,
                  contacts.isEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DisplayEmptyListMsg(
                              msg: l10n.noContactAddedYet,
                              image: AppAssets.addContact,
                            ),
                            AppSpaces.vMedium,
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
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            final contact = contacts[index].data();

                            return UserTile(
                              key: Key(contact.id),
                              userId: contact.contactId,
                            );
                          },
                          separatorBuilder: (ctx, index) => const Divider(),
                          itemCount: contacts.length,
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _updateQuery(String value) {
    setState(() {
      _query = value;
    });
  }

  void _updateParticipants() async {
    final selectedParticipants = ref.watch(selectedContactProvider);
    final group = ref.watch(groupProvider);
    if (group == null) return;

    //add only the one that are not in the member list
    final currentUserId = ref.watch(currentUserIdProvider);
    if (currentUserId == null) return;

    selectedParticipants.add(currentUserId);

    final updatedGroup = group.copyWith(membersIds: selectedParticipants);

    ref
        .read(updateGroupInfoProvider(updatedGroup).future)
        .then((value) {
          ref.read(isLoadingProvider.notifier).state = false;
          context.pop();
        })
        .catchError((error) {
          ref.read(isLoadingProvider.notifier).state = false;
          AppAlerts.displaySnackbar(error.toString());
        });
  }
}

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class ContactsPage extends ConsumerStatefulWidget {
  static ContactsPage builder(BuildContext context, GoRouterState state) =>
      const ContactsPage();
  const ContactsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContactsPageState();
}

class _ContactsPageState extends ConsumerState<ContactsPage> {
  final TextEditingController _searchController = TextEditingController();

  String _query = '';

  @override
  void initState() {
    //for updating user active status according
    //to the app lifecycle events
    UserActiveStatus.setUserStatus(ref);

    Future.delayed(const Duration(seconds: 1), () {
      _requestNotificationPermission();
    });

    _getInitialNotification();

    LocalCache.cacheCurrentUser(ref: ref);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _requestNotificationPermission() async {
    await Future.wait([
      NotificationService.requestNotificationPermission(ref),
      LocalNotificationService().requestIOSPermission(),
      LocalNotificationService().initNotification(),
    ]);
  }

  //when user taps or interact with a notification
  void _getInitialNotification() async {
    await NotificationService.setupInteractedMessage(context);
  }

  @override
  Widget build(BuildContext context) {
    final contactsQuery = ref.watch(contactsQueryProvider);
    final colors = context.colorScheme;
    final l10n = context.l10n;

    return Scaffold(
      appBar: CommonAppBar(
        title: l10n.contacts,
        actions: [
          IconButton(
            onPressed: () => context.push(RouteLocation.addContact),
            icon: Icon(Iconsax.add, size: AppSizes.large),
          ),
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

          return RefreshIndicator.adaptive(
            onRefresh: () async {
              snapshot.fetchMore();
            },
            child: SingleChildScrollView(
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
                  // AppSpaces.vLarge,
                  // const DisplayBannerAd(),
                  AppSpaces.vLarge,
                  contacts.isEmpty
                      ? SizedBox(
                          height: context.deviceSize.height * 0.5,
                          child: DisplayEmptyListMsg(
                            msg: l10n.noContactAddedYet,
                            image: AppAssets.addContact,
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            final contact = contacts[index].data();

                            return InkWell(
                              onTap: () {
                                context.pushNamed(
                                  RouteLocation.contactDetails,
                                  pathParameters: {
                                    AppKeys.userId: contact.contactId,
                                  },
                                );
                              },
                              borderRadius: AppBorders.allSmall,
                              child:
                                  ContactTile(
                                        contact: contact,
                                        key: Key(contact.id),
                                      )
                                      .animate(
                                        delay: Duration(
                                          milliseconds: index * 20,
                                        ),
                                      )
                                      .fade(),
                            );
                          },
                          separatorBuilder: (ctx, index) => const Divider(),
                          itemCount: contacts.length,
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _updateQuery(String value) {
    setState(() {
      _query = value;
    });
  }
}

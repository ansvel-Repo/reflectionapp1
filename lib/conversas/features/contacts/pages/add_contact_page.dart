import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class AddContactPage extends ConsumerStatefulWidget {
  static AddContactPage builder(BuildContext context, GoRouterState state) =>
      const AddContactPage();
  const AddContactPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddContactPageState();
}

class _AddContactPageState extends ConsumerState<AddContactPage> {
  final TextEditingController _searchController = TextEditingController();

  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colorScheme;
    final usersQuery = ref.watch(queryUsersProvider);

    return Scaffold(
      appBar: CommonAppBar(title: l10n.addContacts, centerTitle: true),
      body: PaginatedQueryWidget(
        query: usersQuery,
        builder: (ctx, snapshot) {
          final allUsers = snapshot.docs;

          //get filtered users based on search
          final users = _usersFilteredByQuery(allUsers);

          return RefreshIndicator.adaptive(
            onRefresh: () async {
              snapshot.fetchMore();
            },
            child: SingleChildScrollView(
              padding: AppPaddings.allLarge,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  CommonTextField(
                    controller: _searchController,
                    hintText: l10n.search,
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
                  users.isEmpty
                      ? DisplayAnimatedText(text: l10n.noUser)
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            final user = users[index].data();

                            return Row(
                                  key: Key(user.userId),
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DisplayProfileImg(
                                      imageUrl: user.imageUrl,
                                      username: user.username,
                                    ),
                                    AppSpaces.hSmall,
                                    Expanded(
                                      child: DisplayUsername(user: user),
                                    ),
                                    AppSpaces.hSmaller,
                                    SendRequestButton(user: user),
                                  ],
                                )
                                .animate(delay: Duration(milliseconds: index))
                                .fadeIn();
                          },
                          separatorBuilder: (ctx, index) => const Divider(),
                          itemCount: users.length,
                        ),
                  // const Divider(),
                  // const DisplayBannerAd(),
                  const Divider(),
                  const InviteFriendsButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  QueryUsers _usersFilteredByQuery(QueryUsers allUsers) {
    // Create a Set to ensure uniqueness

    final Set<QueryDocumentSnapshot<AppUser>> uniqueItems =
        <QueryDocumentSnapshot<AppUser>>{};

    // Filter the users based on the query and add them to the Set
    for (var user in allUsers) {
      if (user.data().username.toLowerCase().contains(_query.toLowerCase())) {
        uniqueItems.add(user);
      }
    }

    // Convert the Set back to a List
    return _query.isEmpty ? allUsers : uniqueItems.toList();
  }

  void _updateQuery(String value) {
    setState(() {
      _query = value;
    });
  }
}

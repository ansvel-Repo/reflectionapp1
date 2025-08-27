import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class ContactsStories extends ConsumerWidget {
  const ContactsStories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.read(currentUserIdProvider);
    final contactsQuery = ref.watch(contactsQueryProvider);
    final colors = context.colorScheme;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: AppPaddings.allMedium,
      child: SizedBox(
        width: context.deviceSize.width,
        height: context.deviceSize.height * 0.11,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Expanded(
                  flex: 3,
                  child: InkWell(
                    onTap: () {
                      context.push(RouteLocation.addStory);
                    },
                    borderRadius: AppBorders.allMedium,
                    child: StoryBorder(
                      borderColor: colors.primary,
                      child: ProfileImgContainer(
                        bgColor: colors.onPrimary,
                        child: Center(
                          child: Icon(Iconsax.add, size: AppSizes.large),
                        ),
                      ),
                    ),
                  ),
                ),
                AppSpaces.vSmallest,
                Expanded(
                  child: Text(
                    context.l10n.add,
                    style: context.textStyle.labelSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            AppSpaces.hSmaller,
            Visibility(
              visible: _hasStories(userId: '$currentUserId', ref: ref),
              child: StoryTile(userId: '$currentUserId', isCurrentUser: true),
            ),
            AppSpaces.hSmaller,
            PaginatedQueryWidget<Contact>(
              query: contactsQuery,
              builder: (ctx, snapshot) {
                final allContacts = snapshot.docs;
                final contactsWithStories = _getContactWithStories(
                  allContacts,
                  ref,
                );

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    final contact = contactsWithStories[index].data();
                    final userId = contact.contactId;

                    return StoryTile(key: Key(userId), userId: userId)
                        .animate(delay: Duration(milliseconds: index * 200))
                        .fadeIn();
                  },
                  separatorBuilder: (ctx, index) => AppSpaces.hSmaller,
                  itemCount: contactsWithStories.length,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  QueryContacts _getContactWithStories(QueryContacts contacts, WidgetRef ref) {
    // Create a Set to ensure uniqueness
    final List<QueryDocumentSnapshot<Contact>> contactsWithStories = [];

    for (var contact in contacts) {
      final hasStories = _hasStories(
        userId: contact.data().contactId,
        ref: ref,
      );

      if (hasStories) {
        contactsWithStories.add(contact);
      }
    }
    return contactsWithStories;
  }

  //check if a user (given id) has stories
  bool _hasStories({required WidgetRef ref, required String userId}) {
    return ref.watch(hasStoriesProvider(userId)).asData?.value ?? false;
  }
}

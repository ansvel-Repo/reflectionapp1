import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/features/group/providers/create_group_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class CreateGroupPage extends ConsumerStatefulWidget {
  static CreateGroupPage builder(BuildContext context, GoRouterState state) =>
      const CreateGroupPage();
  const CreateGroupPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddGroupInfoPageState();
}

class _AddGroupInfoPageState extends ConsumerState<CreateGroupPage> {
  late final TextEditingController _groupNameController;
  final TextEditingController _aboutGroupController = TextEditingController();

  @override
  void initState() {
    //add listener for when users write something
    // update the _groupNameController
    _groupNameController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _aboutGroupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedContacts = ref.watch(selectedContactProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final image = ref.watch(selectedImageProvider);
    final colors = context.colorScheme;
    final l10n = context.l10n;
    final canCreateGroup =
        _groupNameController.text.isNotEmpty && selectedContacts.isNotEmpty;

    return Scaffold(
      appBar: CommonAppBar(
        title: l10n.newGroup,
        fontSize: 18,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: canCreateGroup
                ? () {
                    _createGroup(
                      userIds: selectedContacts,
                      context: context,
                      image: image,
                    );
                  }
                : null,
            child: isLoading
                ? const LoadingIndicator()
                : Text(
                    l10n.create,
                    style: context.textStyle.titleMedium?.copyWith(
                      color: canCreateGroup ? colors.primary : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          AppSpaces.hSmallest,
        ],
      ),
      body: SingleChildScrollView(
        padding: AppPaddings.allLarge,
        child: Column(
          children: [
            CustomContainer(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () =>
                            AppHelpers.getImageFromGallery(ref: ref),
                        icon: CircleAvatar(
                          backgroundColor: colors.primary,
                          maxRadius: AppRadius.kRadiusLarge,
                          backgroundImage: image != null
                              ? FileImage(File(image.path))
                              : null,
                          child: image == null
                              ? Icon(Iconsax.camera, color: colors.surface)
                              : null,
                        ),
                      ),
                      AppSpaces.hSmallest,
                      Expanded(
                        child: Column(
                          children: [
                            AppSpaces.vSmaller,
                            CommonTextField(
                              maxLines: 1,
                              controller: _groupNameController,
                              hintText: l10n.groupName,
                              contentPadding: AppPaddings.h16,
                            ),
                            AppSpaces.vMedium,
                            CommonTextField(
                              maxLines: 3,
                              controller: _aboutGroupController,
                              hintText: l10n.aboutGroup,
                              contentPadding: AppPaddings.allMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const DisplaySelectedContacts(isGroupInfo: true),
            // AppSpaces.vLarge,
            // const DisplayBannerAd(),
            AppSpaces.vLarge,
          ],
        ),
      ),
    );
  }

  void _createGroup({
    required List<String> userIds,
    XFile? image,
    required BuildContext context,
  }) async {
    final l10n = context.l10n;
    FocusScope.of(context).unfocus();

    final String name = _groupNameController.text.trim();
    final String about = _aboutGroupController.text.trim();

    final currentUser = LocalCache.getCurrentUser();
    if (currentUser == null) return;

    ref.read(isLoadingProvider.notifier).state = true;

    final currentUserId = currentUser.userId;

    //add current user (group creator) to the member list
    userIds.add(currentUserId);

    final group = GroupModel(
      groupId: '',
      name: name,
      imageUrl: '',
      about: about,
      membersIds: userIds,
      adminsIds: [currentUserId],
      createdAt: Timestamp.now(),
      lastActivity: Timestamp.now(),
      groupCreator: currentUser.username,
    );

    await ref
        .read(createGroupProvider.notifier)
        .createGroup(group, image)
        .then((value) {
          ref.read(isLoadingProvider.notifier).state = false;
          AppAlerts.displaySnackbar(l10n.groupCreatedSuccessfully);
          context.go(RouteLocation.chats);
        })
        .catchError((error) {
          ref.read(isLoadingProvider.notifier).state = false;
          AppAlerts.displaySnackbar(error.toString());
        });
  }
}

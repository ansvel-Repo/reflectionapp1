import 'dart:io';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class UpdateUserProfile extends ConsumerStatefulWidget {
  const UpdateUserProfile({super.key, required this.user});
  final AppUser user;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateUserProfileState();
}

class _UpdateUserProfileState extends ConsumerState<UpdateUserProfile> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  @override
  void initState() {
    _usernameController.text = widget.user.username;
    _aboutController.text = widget.user.about;
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = ref.watch(selectedImageProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final userImgUrl = widget.user.imageUrl;
    final colors = context.colorScheme;
    final l10n = context.l10n;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: Icon(Iconsax.close_circle, color: colors.primary),
              ),
            ],
          ),
          Text(l10n.changeImage),
          AppSpaces.vSmall,
          Column(
            children: [
              Stack(
                children: [
                  IconButton(
                    onPressed: () async {
                      await AppHelpers.getImageFromGallery(ref: ref);
                    },
                    icon: Column(
                      children: [
                        Visibility(
                          visible: image == null,
                          child: userImgUrl.isEmpty
                              ? DisplayCustomImg(
                                  name: widget.user.username,
                                  isCircleAvatar: true,
                                  maxRadius: AppRadius.kRadiusLarger,
                                  fontSize: AppSizes.large,
                                )
                              : DisplayImageFromUrl(
                                  imgUrl: userImgUrl,
                                  isCircleAvatar: true,
                                  maxRadius: AppRadius.kRadiusLarger,
                                ),
                        ),
                        Visibility(
                          visible: image != null,
                          child: CircleAvatar(
                            maxRadius: AppRadius.kRadiusLarger,
                            backgroundImage: image != null
                                ? FileImage(File(image.path))
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 70.h,
                    bottom: 0,
                    right: 12.w,
                    child: Icon(
                      Icons.add_a_photo,
                      color: colors.inversePrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          AppSpaces.vMedium,
          Padding(
            padding: AppPaddings.allLargest,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Form(
                  key: _formKey,
                  child: CommonTextField(
                    controller: _usernameController,
                    hintText: l10n.enterYourName,
                  ),
                ),
                AppSpaces.vSmall,
                CommonTextField(readOnly: true, hintText: widget.user.email),
                AppSpaces.vSmall,
                CommonTextField(
                  maxLines: 3,
                  controller: _aboutController,
                  hintText: l10n.tellAboutYou,
                  contentPadding: AppPaddings.allMedium,
                ),
                AppSpaces.vLarge,
                CommonOutlinedButton(
                  onPressed: () => _updateUserImageProfile(widget.user),
                  child: isLoading
                      ? const LoadingIndicator()
                      : Text(l10n.updateProfile),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _updateUserImageProfile(AppUser user) async {
    final l10n = context.l10n;

    final bool isValid = _formKey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus();

    if (isValid) {
      ref.read(isLoadingProvider.notifier).state = true;
      _formKey.currentState?.save();
      user = user.copyWith(
        username: _usernameController.text.trim(),
        about: _aboutController.text.trim(),
      );

      await ref
          .read(updateUserProfileProvider(user).future)
          .then((value) {
            ref.read(isLoadingProvider.notifier).state = false;
            AppAlerts.displaySnackbar(l10n.profileUpdateSuccessfully);
            context.pop();
          })
          .catchError((error) {
            ref.read(isLoadingProvider.notifier).state = false;
            AppAlerts.displaySnackbar(l10n.somethingWentWrong);
            context.pop();
          });
    }
  }
}

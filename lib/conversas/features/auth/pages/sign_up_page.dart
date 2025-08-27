import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static SignUpPage builder(BuildContext context, GoRouterState state) =>
      const SignUpPage();

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> with Validators {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  bool isTermConditionAccepted = false;

  @override
  @override
  void dispose() {
    // _emailController.dispose();
    // _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isObscureTextPassword = ref.watch(signUpShowPasswordProvider);
    final image = ref.watch(selectedImageProvider);
    final bool isLoading = ref.watch(isLoadingProvider);
    final l10n = context.l10n;

    final showPasswordIcon = isObscureTextPassword
        ? const Icon(Iconsax.eye_slash)
        : const Icon(Iconsax.eye);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppPaddings.allLarge,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppSpaces.vMedium,

                Row(
                  children: [
                    SizedBox(
                      width: context.deviceSize.width * 0.2,
                      child: const Image(
                        image: AppAssets.logo,
                      ).animate().fade(delay: 300.ms, duration: 900.ms).fade(),
                    ),
                    AnimatedTextKit(
                      animatedTexts: [
                        TyperAnimatedText(
                          l10n.createAccount,
                          textStyle: context.textStyle.headlineLarge,
                        ),
                      ],
                    ),
                  ],
                ),
                //this column is to center the stack
                Column(
                  children: [
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () async {
                            await AppHelpers.getImageFromGallery(ref: ref);
                          },
                          icon: CircleAvatar(
                            maxRadius: AppRadius.kRadiusLarger,
                            backgroundImage: image != null
                                ? FileImage(File(image.path))
                                : null,
                            child: image == null
                                ? Icon(
                                    Iconsax.user,
                                    color: context.colorScheme.primary,
                                  )
                                : null,
                          ),
                        ),
                        Positioned(
                          top: 90,
                          bottom: 0,
                          right: 15,
                          child: Icon(
                            Icons.add_a_photo,
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                AppSpaces.vLarge,
                CommonTextField(
                  controller: _usernameController,
                  key: const ValueKey('username'),
                  autofillHints: const [AutofillHints.username],
                  prefixIcon: const Icon(Iconsax.user),
                  hintText: l10n.enterYourName,
                  validator: (value) =>
                      isEmpty(value, l10n.thisFieldIsRequired),
                ),
                // AppSpaces.vLarge,
                // CommonTextField(
                //   controller: _emailController,
                //   key: const ValueKey('email'),
                //   keyboardType: TextInputType.emailAddress,
                //   autofillHints: const [AutofillHints.email],
                //   prefixIcon: const Icon(Icons.email_outlined),
                //   hintText: l10n.enterEmail,
                //   validator: (value) {
                //     return combineValidators([
                //       () => isEmpty(value, l10n.thisFieldIsRequired),
                //       () => isEmail(value, l10n.enterValidEmailAddress),
                //     ]);
                //   },
                // ),
                // AppSpaces.vLarge,
                // CommonTextField(
                //   controller: _passwordController,
                //   key: const ValueKey('password'),
                //   obscureText: isObscureTextPassword,
                //   hintText: l10n.enterPassword,
                //   autofillHints: const [AutofillHints.password],
                //   maxLines: 1,
                //   prefixIcon: Icon(
                //     isObscureTextPassword ? Iconsax.lock : Iconsax.unlock,
                //   ),
                //   suffixIcon: IconButton(
                //     onPressed: () {
                //       ref.read(signUpShowPasswordProvider.notifier).state =
                //           !isObscureTextPassword;
                //     },
                //     icon: showPasswordIcon,
                //   ),
                //   validator: (value) {
                //     return combineValidators([
                //       () => isEmpty(value, l10n.thisFieldIsRequired),
                //       () => hasSevenChars(value, l10n.passwordMustHave),
                //     ]);
                //   },
                // ),
                AppSpaces.vSmall,
                Row(
                  children: [
                    Checkbox(
                      value: isTermConditionAccepted,
                      activeColor: context.colorScheme.primary,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            isTermConditionAccepted = value;
                          });
                        }
                      },
                    ),
                    TextButton(
                      onPressed: _openTermsConditionsUrl,
                      child: Text(l10n.termsAndConditions),
                    ),
                  ],
                ),
                AppSpaces.vSmall,
                CommonOutlinedButton(
                  onPressed: isTermConditionAccepted
                      ? () => _signUp(image)
                      : null,
                  child: Padding(
                    padding: AppPaddings.v16,
                    child: isLoading
                        ? const LoadingIndicator()
                        : Text(l10n.signUp),
                  ),
                ),
                AppSpaces.vMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.alreadyHaveAnAccount,
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: () => context.go(RouteLocation.login),
                      child: Text(l10n.login),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signUp(XFile? image) async {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus();

    if (isValid) {
      ref.read(isLoadingProvider.notifier).state = true;
      _formKey.currentState?.save();
      final String username = _usernameController.text.trim();
      // final String email = _emailController.text.trim();
      // final String password = _passwordController.text.trim();

      // Only collect username and image, skip authentication
      final user = AppUser(
        userId: '',
        imageUrl: '',
        pushToken: '',
        email: '', // email removed
        isOnline: true,
        username: username,
        createdAt: Timestamp.now(),
        lastActive: Timestamp.now(),
        about: context.l10n.aboutMessage,
      );

      // Skip actual signUp/authentication, just mark as logged in
      _isLoggedIn(true);
    }
  }

  void _isLoggedIn(bool value) async {
    //cache user auth state
    await SharedPrefs.instance.setBool(AppKeys.isLoggedIn, value);

    //cancel loading
    ref.read(isLoadingProvider.notifier).state = false;

    //will trigger the routeProvider
    //and move to the main screen if true,
    // if not will stay at login screen
    ref.read(isLoggedInProvider.notifier).state = value;
  }

  void _openTermsConditionsUrl() {
    const url = AppLinks.termsConditions;
    AppHelpers.openUrl(url);
  }
}

import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';

class ForgetPasswordPage extends ConsumerStatefulWidget {
  static ForgetPasswordPage builder(
    BuildContext context,
    GoRouterState state,
  ) => const ForgetPasswordPage();
  const ForgetPasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends ConsumerState<ForgetPasswordPage>
    with Validators {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingProvider);
    final deviceSize = context.deviceSize;
    final l10n = context.l10n;

    return Scaffold(
      appBar: CommonAppBar(title: l10n.appTitle),
      body: SingleChildScrollView(
        padding: AppPaddings.allLarge,
        physics: const AlwaysScrollableScrollPhysics(),
        child: SafeArea(
          child: SizedBox(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Image(
                    image: AppAssets.resetPassword,
                  ).animate().fade(delay: 300.ms, duration: 700.ms).fade(),
                  AppSpaces.vMedium,
                  DisplayAnimatedText(
                    text: l10n.forgotPassword,
                    textStyle: context.textStyle.headlineLarge,
                  ),
                  AppSpaces.vMedium,
                  Text(l10n.kindlyProvideYourEmailAddress),
                  AppSpaces.vLarge,
                  CommonTextField(
                    key: const ValueKey('email'),
                    controller: _emailController,
                    hintText: l10n.enterEmail,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    textInputAction: TextInputAction.done,
                    suffixIcon: Icon(
                      Icons.email_outlined,
                      color: context.colorScheme.primary,
                    ),
                    validator: (value) {
                      return combineValidators([
                        () => isEmpty(value, l10n.thisFieldIsRequired),
                        () => isEmail(value, l10n.enterValidEmailAddress),
                      ]);
                    },
                  ),
                  AppSpaces.vLarge,
                  ElevatedButton(
                    onPressed: _resetPassword,
                    child: isLoading
                        ? const LoadingIndicator()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Iconsax.send_square),
                              AppSpaces.hSmall,
                              Text(l10n.requestLink),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _resetPassword() async {
    final l10n = context.l10n;
    final bool isValid = _formKey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus();

    if (isValid) {
      ref.read(isLoadingProvider.notifier).state = true;
      _formKey.currentState?.save();
      final String email = _emailController.text.trim();

      await ref
          .read(resetPasswordProvider(email).future)
          .then((value) {
            AppAlerts.displaySnackbar(l10n.weSentAnEmailToReset);
            ref.read(isLoadingProvider.notifier).state = false;
            _emailController.clear();
          })
          .catchError((error) {
            AppAlerts.displaySnackbar(error);
            ref.read(isLoadingProvider.notifier).state = false;
          });
    }
  }
}

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ansvel/conversas/features/auth/pages/sign_up_page.dart';

/// GlobalKey to access LoginPage state externally
final GlobalKey<_LoginPageState> conversasLoginKey =
    GlobalKey<_LoginPageState>();

class LoginPage extends ConsumerStatefulWidget {
  // Accept a key parameter for external access
  const LoginPage({Key? key}) : super(key: key);
  static LoginPage builder(BuildContext context, GoRouterState state) =>
      LoginPage(key: conversasLoginKey);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> with Validators {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _checkedSignup = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Call this from the main application after successful external login
  void onConvasaExternalLoginSuccess() {
    _isLoggedIn(true);
  }

  // The original _login method is now disabled for email/password login
  // void _login() async {
  //   final bool isValid = _formKey.currentState?.validate() ?? false;
  //   FocusScope.of(context).unfocus();
  //   if (isValid) {
  //     ref.read(isLoadingProvider.notifier).state = true;
  //     _formKey.currentState?.save();
  //     final String email = _emailController.text.trim();
  //     final String password = _passwordController.text.trim();
  //     await ref
  //         .read(authProvider.notifier)
  //         .logIn(email, password)
  //         .then((value) {
  //       _isLoggedIn(true);
  //     }).catchError((error) {
  //       _isLoggedIn(false);
  //       AppAlerts.displaySnackbar(error.toString());
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // The login page UI is now disabled for external authentication integration.
    // To re-enable, uncomment the code below.
    /*
    final l10n = context.l10n;
    final deviceSize = context.deviceSize;
    final isLoading = ref.watch(isLoadingProvider);
    final isObscureTextPassword = ref.watch(loginShowPasswordProvider);
    final showPasswordIcon = isObscureTextPassword
        ? const Icon(Iconsax.eye_slash)
        : const Icon(Iconsax.eye);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppPaddings.allLarge,
          physics: const AlwaysScrollableScrollPhysics(),
          child: SafeArea(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppSpaces.vMedium,
                    SizedBox(
                      height: deviceSize.height * 0.15,
                      width: deviceSize.width * 0.4,
                      child: const Image(
                        image: AppAssets.logo,
                      ).animate().fade(delay: 300.ms, duration: 900.ms).fade(),
                    ),
                    Flexible(
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TyperAnimatedText(
                            l10n.welcomeBack,
                            textStyle: context.textStyle.headlineLarge,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    AppSpaces.vLarge,
                    CommonTextField(
                      key: const ValueKey('email'),
                      controller: _emailController,
                      hintText: l10n.enterEmail,
                      labelText: l10n.email,
                      prefixIcon: const Icon(Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        return combineValidators([
                          () => isEmpty(
                                value,
                                l10n.thisFieldIsRequired,
                              ),
                          () => isEmail(value, l10n.enterValidEmailAddress),
                        ]);
                      },
                    ),
                    AppSpaces.vLarge,
                    CommonTextField(
                      key: const ValueKey('password'),
                      controller: _passwordController,
                      obscureText: isObscureTextPassword,
                      hintText: l10n.enterPassword,
                      labelText: l10n.password,
                      prefixIcon: Icon(
                        isObscureTextPassword ? Iconsax.lock : Iconsax.unlock,
                      ),
                      maxLines: 1,
                      autofillHints: const [AutofillHints.password],
                      suffixIcon: IconButton(
                        onPressed: () {
                          ref.read(loginShowPasswordProvider.notifier).state =
                              !isObscureTextPassword;
                        },
                        icon: showPasswordIcon,
                      ),
                      validator: (value) {
                        return combineValidators([
                          () => isEmpty(value, l10n.thisFieldIsRequired),
                          () => hasSevenChars(value, l10n.passwordMustHave),
                        ]);
                      },
                    ),
                    AppSpaces.vLarge,
                    CommonOutlinedButton(
                      onPressed: _login,
                      child: Padding(
                        padding: AppPaddings.v16,
                        child: isLoading
                            ? const LoadingIndicator()
                            : Text(l10n.login),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () {
                            context.push(RouteLocation.forgetPassword);
                          },
                          child: Text('l10n.forgotPassword}?'),
                        ),
                      ],
                    ),
                    AppSpaces.vMedium,
                    // const GoogleSignInButton(),
                    AppSpaces.vMedium,
                    Row(
                      children: [
                        Text(
                          l10n.dontHaveAccount,
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                          onPressed: () => context.go(RouteLocation.signup),
                          child: Text(l10n.signUp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    */
    // Show nothing or a placeholder while login is handled externally
    return const SizedBox.shrink();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _showSignupIfFirstTime();
  }

  Future<void> _showSignupIfFirstTime() async {
    if (_checkedSignup) return;
    _checkedSignup = true;
    final hasSignedUp =
        await SharedPrefs.instance.getBool('hasSignedUp') ?? false;
    if (!hasSignedUp) {
      // Show signup page and set flag after
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const SignUpPage()));
      await SharedPrefs.instance.setBool('hasSignedUp', true);
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
}

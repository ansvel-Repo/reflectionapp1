import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // Google Sign-In is disabled
  }
}

// class GoogleSignInButton extends ConsumerWidget {
//   const GoogleSignInButton({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final l10n = context.l10n;
//
//     return CommonOutlinedButton(
//       onPressed: () => _login(ctx: context, ref: ref),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const FaIcon(FontAwesomeIcons.google),
//           AppSpaces.hSmall,
//           Padding(padding: AppPaddings.v16, child: Text(l10n.loginpWithGoogle)),
//         ],
//       ),
//     );
//   }
//
//   void _login({required WidgetRef ref, required BuildContext ctx}) async {
//     final l10n = ctx.l10n;
//     await ref
//         .read(googleSignInProvider.future)
//         .then((authResult) {
//           if (authResult) {
//             _isLoggedIn(ref: ref, authResult: authResult);
//           }
//         })
//         .catchError((_) {
//           _isLoggedIn(ref: ref, authResult: false);
//           return AppAlerts.displaySnackbar(l10n.somethingWentWrong);
//         });
//   }
//
//   void _isLoggedIn({required WidgetRef ref, required bool authResult}) async {
//     //cache user auth state
//     await SharedPrefs.instance.setBool(AppKeys.isLoggedIn, authResult);
//
//     //cancel loading
//     ref.read(isLoadingProvider.notifier).state = false;
//
//     //after login cache currentUser info
//     if (authResult) {
//       final userId = ref.watch(currentUserIdProvider);
//       if (userId == null) return;
//       LocalCache.cacheCurrentUserId(id: userId);
//       LocalCache.cacheCurrentUser(ref: ref);
//     }
//
//     //will trigger the routeProvider
//     //and move to the main screen if true,
//     // if not will stay at login screen
//     ref.read(isLoggedInProvider.notifier).state = authResult;
//   }
// }

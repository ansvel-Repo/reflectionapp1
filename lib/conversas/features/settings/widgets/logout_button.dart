import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Iconsax.logout_14, color: context.colorScheme.primary),
      title: Text(l10n.logout),
      trailing: InkWell(
        onTap: () => AppAlerts.displayAlertDialog(
          context: context,
          title: l10n.logout,
          content: l10n.areYouSureYouWantLogout,
          onConfirmation: () => _logout(ref: ref, context: context),
        ),
        borderRadius: AppBorders.allLarge,
        child: Icon(
          Icons.keyboard_arrow_right_rounded,
          size: AppSizes.larger,
          color: context.colorScheme.primary,
        ),
      ),
    );
  }

  void _logout({required BuildContext context, required WidgetRef ref}) async {
    //cache user auth state
    await ref.read(logoutProvider.future).then((value) {
      ref.read(isLoggedInProvider.notifier).state = false;
    });
  }
}

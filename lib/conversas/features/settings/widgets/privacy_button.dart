import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class PrivacyButton extends StatelessWidget {
  const PrivacyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Iconsax.security_safe, color: context.colorScheme.primary),
      title: Text(context.l10n.privacy),
      trailing: InkWell(
        onTap: _openPrivacyUrl,
        borderRadius: AppBorders.allLarge,
        child: Icon(
          Icons.keyboard_arrow_right_rounded,
          color: context.colorScheme.primary,
          size: AppSizes.larger,
        ),
      ),
    );
  }

  void _openPrivacyUrl() {
    const url = AppLinks.privacy;
    AppHelpers.openUrl(url);
  }
}

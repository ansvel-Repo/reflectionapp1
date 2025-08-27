import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class HelpButton extends StatelessWidget {
  const HelpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Iconsax.message_question,
        color: context.colorScheme.primary,
      ),
      title: Text(context.l10n.help),
      trailing: InkWell(
        onTap: _openHelpUrl,
        borderRadius: AppBorders.allLarge,
        child: Icon(
          Icons.keyboard_arrow_right_rounded,
          color: context.colorScheme.primary,
          size: AppSizes.larger,
        ),
      ),
    );
  }

  void _openHelpUrl() {
    const url = AppLinks.help;
    AppHelpers.openUrl(url);
  }
}

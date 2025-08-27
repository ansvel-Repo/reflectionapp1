import 'package:ansvel/conversas/common/common.dart';
import 'package:flutter/material.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:share_plus/share_plus.dart';

class InviteFriendsButton extends StatelessWidget {
  const InviteFriendsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colorScheme;
    final inviteMsg = l10n.inviteText("conversas.com");

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.email_outlined, color: colors.primary),
      title: Text(l10n.inviteFriends),
      trailing: InkWell(
        onTap: () => _openShareSheet(inviteMsg),
        borderRadius: AppBorders.allLarge,
        child: Icon(
          Icons.keyboard_arrow_right_rounded,
          size: AppSizes.larger,
          color: colors.primary,
        ),
      ),
    );
  }

  static Future<void> _openShareSheet(String inviteMsg) async {
    await Share.share(inviteMsg);
  }
}

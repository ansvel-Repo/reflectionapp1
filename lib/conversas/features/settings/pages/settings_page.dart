import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class SettingsPage extends StatelessWidget {
  static SettingsPage builder(BuildContext context, GoRouterState state) =>
      const SettingsPage();
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = LocalCache.getCurrentUser();
    final colors = context.colorScheme;
    final l10n = context.l10n;

    return Scaffold(
      appBar: const CommonAppBar(),
      body: SingleChildScrollView(
        padding: AppPaddings.allMedium,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const DisplayUserInfo(),
            const AllowNotificationsButton(),
            const SwitchThemeButton(),
            const LanguageSelector(),
            const Divider(),
            const InviteFriendsButton(),
            const HelpButton(),
            const PrivacyButton(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Iconsax.info_circle,
                color: context.colorScheme.primary,
              ),
              title: Text(l10n.version),
              trailing: InkWell(
                onTap: () => context.push(RouteLocation.appVersion),
                borderRadius: AppBorders.allLarge,
                child: Icon(
                  Icons.keyboard_arrow_right_rounded,
                  size: AppSizes.larger,
                  color: context.colorScheme.primary,
                ),
              ),
            ),
            const LogoutButton(),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Iconsax.calendar,
                color: context.colorScheme.primary,
              ),
              title: Text(l10n.joinedDate),
              subtitle: Text(
                user == null ? '' : AppHelpers.formatTimestamp(user.createdAt),
              ),
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Iconsax.warning_2, color: colors.error),
              title: Text(
                l10n.deleteAccount,
                style: context.textStyle.bodyLarge?.copyWith(
                  color: colors.error,
                ),
              ),
              trailing: IconButton(
                onPressed: () => context.push(RouteLocation.deleteAccount),
                icon: Icon(
                  Icons.keyboard_arrow_right_rounded,
                  size: AppSizes.larger,
                  color: colors.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

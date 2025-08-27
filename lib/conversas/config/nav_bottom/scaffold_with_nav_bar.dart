import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  static ScaffoldWithNavBar builder(StatefulNavigationShell navigationShell) =>
      ScaffoldWithNavBar(navigationShell: navigationShell);

  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AnnotatedRegion(
      value: FlexColorScheme.themedSystemNavigationBar(
        context,
        systemNavBarStyle: FlexSystemNavBarStyle.transparent,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          destinations: [
            NavigationDestination(
              label: l10n.contacts,
              icon: const Icon(Iconsax.people),
            ),
            NavigationDestination(
              label: l10n.chats,
              icon: const Icon(Iconsax.message),
            ),
            NavigationDestination(
              label: l10n.notifications,
              icon: const NotificationIcon(),
            ),
            NavigationDestination(
              label: l10n.more,
              icon: const Icon(Iconsax.more),
            ),
          ],
          onDestinationSelected: _goBranch,
        ),
      ),
    );
  }
}

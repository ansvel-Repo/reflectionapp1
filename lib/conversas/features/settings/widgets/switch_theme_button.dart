import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class SwitchThemeButton extends ConsumerWidget {
  const SwitchThemeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Iconsax.moon, color: context.colorScheme.primary),
      title: Text(context.l10n.darkMode),
      trailing: Switch(
        value: themeState == ThemeMode.dark,
        onChanged: (value) {
          ref.read(themeProvider.notifier).changeTheme(value);
        },
      ),
    );
  }
}

import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLanguage = ref.watch(appLocaleProvider);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Iconsax.language_square,
        color: context.colorScheme.primary,
      ),
      title: Text(context.l10n.language),
      trailing: InkWell(
        onTap: () {
          //language change
        },
        borderRadius: AppBorders.allLarge,
        child: DropdownButton<Locale>(
          value: selectedLanguage,
          icon: Row(
            children: [
              AppSpaces.hSmallest,
              Icon(Iconsax.global, color: context.colorScheme.primary),
            ],
          ),
          alignment: AlignmentDirectional.bottomEnd,
          borderRadius: AppBorders.allSmall,
          underline: const SizedBox(),
          onChanged: (Locale? locale) {
            if (locale != null) {
              ref.read(appLocaleProvider.notifier).setLocale(locale);
            }
          },
          items: _getSupportedLocale().map<DropdownMenuItem<Locale>>((
            Locale locale,
          ) {
            return DropdownMenuItem<Locale>(
              value: locale,
              child: Text(
                _localeName(locale: locale, context: context),
                style: context.textStyle.bodyMedium?.copyWith(
                  color: context.colorScheme.primary,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  List<Locale> _getSupportedLocale() {
    return List.generate(
      AppLocale.values.length,
      (index) => AppLocale.values[index].locale,
    );
  }

  String _localeName({required Locale locale, required BuildContext context}) {
    final l10n = context.l10n;
    String language = l10n.english;

    if (locale == AppLocale.en.locale) {
      language = l10n.english;
    }
    if (locale == AppLocale.pt.locale) {
      language = l10n.portuguese;
    }

    return language;
  }
}

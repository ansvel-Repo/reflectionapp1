import 'package:ansvel/conversas/config/localization/arb/app_localizations.dart';
import 'package:flutter/widgets.dart';

extension ConversasLocalizations on BuildContext {
  AppLocalizations get l10n {
    final localizations = AppLocalizations.of(this);
    return localizations;
  }
}
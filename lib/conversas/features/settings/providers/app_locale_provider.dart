import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appLocaleProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final prefs = SharedPrefs.instance;
  return LocaleNotifier(prefs);
});

class LocaleNotifier extends StateNotifier<Locale> {
  final SharedPreferences _prefs;
  LocaleNotifier(this._prefs) : super(AppLocale.en.locale) {
    _initLocale();
  }

  void _initLocale() {
    try {
      final locale = _prefs.getString(AppKeys.locale) ?? 'en_US';
      if (locale == 'en_US') {
        state = AppLocale.en.locale;
      }

      if (locale == 'pt_BR') {
        state = AppLocale.pt.locale;
      }
    } on Exception catch (_) {
      state = AppLocale.en.locale;
    }
  }

  void setLocale(Locale locale) async {
    state = locale;
    await _prefs.setString(AppKeys.locale, locale.toString());
  }
}

enum AppLocale {
  en(Locale('en', 'US')),
  pt(Locale('pt', 'BR'));

  final Locale locale;
  const AppLocale(this.locale);
}

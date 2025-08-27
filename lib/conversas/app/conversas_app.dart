import 'package:ansvel/conversas/config/localization/arb/app_localizations.dart' as app_localizations;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';

class ConversasApp extends ConsumerWidget {
  const ConversasApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final routeConfig = ref.watch(routesProvider);
    final appLocale = ref.watch(appLocaleProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          routerConfig: routeConfig,
          scrollBehavior: const ScrollBehavior().copyWith(
            physics: const BouncingScrollPhysics(),
          ),
          locale: appLocale,
          localizationsDelegates: app_localizations.AppLocalizations.localizationsDelegates,
          supportedLocales: app_localizations.AppLocalizations.supportedLocales,
          scaffoldMessengerKey: scaffoldMessengerKey,
        );
      },
    );
  }
}

//This is global key used to access snackbar
//anywhere in the app without context
GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

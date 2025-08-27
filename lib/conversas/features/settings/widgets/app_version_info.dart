import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class AppVersionInfo extends StatelessWidget {
  static AppVersionInfo builder(BuildContext context, GoRouterState state) =>
      const AppVersionInfo();
  const AppVersionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final appInfo = AppPackageInfo.instance;
    final deviceSize = context.deviceSize;
    final l10n = context.l10n;
    final year = DateTime.now().year;
    final version = appInfo.version;
    final buildNumber = appInfo.buildNumber;
    final allRights = l10n.incAllRightsReserved;

    return Scaffold(
      appBar: CommonAppBar(title: l10n.appVersion, centerTitle: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AppAssets.logo,
            height: deviceSize.height * 0.15,
            width: deviceSize.width * 0.15,
          ),
          AppSpaces.vLarge,
          Column(
            children: [
              Text(
                '${l10n.version} $version',
                style: context.textStyle.titleLarge,
              ),
              Text(
                '${l10n.buildNumber}: $buildNumber',
                style: context.textStyle.titleMedium,
              ),
              AppSpaces.vLarge,
              Text(
                '${l10n.copyright} $year ${l10n.appTitle}, \n$allRights',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          AppSpaces.vLargest,
        ],
      ).animate().fade(delay: 300.ms, duration: 700.ms).fade(),
    );
  }
}

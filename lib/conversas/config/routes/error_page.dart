import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorPage extends StatelessWidget {
  static ErrorPage builder(BuildContext context, GoRouterState state) =>
      const ErrorPage();
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textStyle;

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go(RouteLocation.contacts),
          child: Text(l10n.somethingWentWrong, style: textTheme.bodyMedium),
        ),
      ),
    );
  }
}

import 'package:ansvel/conversas/app/conversas_app.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppAlerts {
  const AppAlerts._();

  static displaySnackbar(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  //display image at full size
  static void showFullImageDialog(BuildContext context, String imgUrl) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (ctx, animation, animation2) {
        return ShowFullImageDialog(imageUrl: imgUrl);
      },
    );
  }

  static void displayAlertDialog({
    required BuildContext context,
    required String title,
    required String content,
    VoidCallback? onConfirmation,
  }) async {
    return await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog.adaptive(
          title: Text(title, textAlign: TextAlign.center),
          content: Text(content, textAlign: TextAlign.center),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: onConfirmation,
              child: Center(child: Text(ctx.l10n.yes.toUpperCase())),
            ),
            TextButton(
              onPressed: () => ctx.pop(),
              child: Center(child: Text(ctx.l10n.no.toUpperCase())),
            ),
          ],
        );
      },
    );
  }
}

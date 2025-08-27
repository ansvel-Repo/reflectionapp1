import 'package:ansvel/conversas/common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AllowNotificationsButton extends ConsumerWidget {
  const AllowNotificationsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAllowed = ref.watch(subscribeNotificationProvider);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Iconsax.notification, color: context.colorScheme.primary),
      title: Text(context.l10n.notifications),
      trailing: Switch(
        value: isAllowed,
        onChanged: (value) {
          ref
              .read(subscribeNotificationProvider.notifier)
              .allNotifications(value);

          //update users notifications permission
          NotificationService.getUserToken(ref);
        },
      ),
    );
  }
}

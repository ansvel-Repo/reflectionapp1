import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class NotificationIcon extends ConsumerWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalRequests = ref.watch(totalRequestsProvider);

    return AsyncValueWidget(
      value: totalRequests,
      data: (total) {
        return IconBadge(
          key: const Key('NotificationIcon'),
          counter: total,
          icon: Iconsax.notification,
        );
      },
    );
  }
}

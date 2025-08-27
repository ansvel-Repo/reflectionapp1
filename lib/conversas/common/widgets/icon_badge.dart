import 'package:badges/badges.dart' as badges;
import 'package:ansvel/conversas/common/common.dart';
import 'package:flutter/material.dart';

class IconBadge extends StatelessWidget {
  const IconBadge({super.key, required this.counter, required this.icon});

  final int counter;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return badges.Badge(
      badgeContent: Text(
        '$counter',
        style: context.textStyle.labelSmall?.copyWith(color: colors.surface),
      ),
      showBadge: counter > 0,
      badgeStyle: badges.BadgeStyle(badgeColor: colors.primary),
      badgeAnimation: const badges.BadgeAnimation.fade(),
      child: Icon(icon),
    );
  }
}

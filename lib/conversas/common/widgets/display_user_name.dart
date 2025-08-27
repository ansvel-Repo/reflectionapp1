import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:badges/badges.dart' as badges;
import 'package:ansvel/conversas/common/common.dart';
import 'package:flutter/material.dart';

class DisplayUsername extends StatelessWidget {
  const DisplayUsername({
    super.key,
    required this.user,
    this.fontSize,
    this.textColor,
  });

  final AppUser user;
  final double? fontSize;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  AppHelpers.formatUsername(user.username),
                  style: context.textStyle.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                    color: textColor,
                  ),
                  maxLines: 1,
                ),
              ),
              AppSpaces.hSmallest,
              badges.Badge(
                badgeContent: Icon(
                  Icons.check,
                  size: AppSizes.smallest,
                  color: colors.surface,
                ),
                position: badges.BadgePosition.topEnd(),
                badgeStyle: badges.BadgeStyle(
                  shape: badges.BadgeShape.twitter,
                  badgeColor: colors.primary,
                ),
                badgeAnimation: const badges.BadgeAnimation.scale(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

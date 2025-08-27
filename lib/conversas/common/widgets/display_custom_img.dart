import 'package:ansvel/conversas/common/common.dart';
import 'package:flutter/material.dart';

class DisplayCustomImg extends StatelessWidget {
  const DisplayCustomImg({
    Key? key,
    required this.name,
    this.isCircleAvatar = false,
    this.maxRadius,
    this.fontSize,
  }) : super(key: key);
  final String name;
  final bool isCircleAvatar;
  final double? maxRadius;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return isCircleAvatar
        ? CircleAvatar(
            backgroundColor: colors.primary,
            maxRadius: maxRadius,
            child: Center(
              child: Text(
                AppHelpers.getFirstUsernameChar(name),
                style: context.textStyle.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.surface,
                  fontSize: fontSize,
                ),
              ),
            ),
          )
        : ProfileImgContainer(
            bgColor: colors.primary,
            child: Center(
              child: Text(
                AppHelpers.getFirstUsernameChar(name),
                style: context.textStyle.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                  color: colors.surface,
                ),
              ),
            ),
          );
  }
}

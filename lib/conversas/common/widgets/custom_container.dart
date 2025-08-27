import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({super.key, this.child, this.alignment, this.height});

  final Widget? child;
  final AlignmentGeometry? alignment;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: context.deviceSize.width,
      padding: AppPaddings.allSmall,
      decoration: BoxDecoration(
        borderRadius: AppBorders.allSmall,
        color: context.colorScheme.surfaceVariant,
      ),
      alignment: alignment,
      child: child,
    );
  }
}

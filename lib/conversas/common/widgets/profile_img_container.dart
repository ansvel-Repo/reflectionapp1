import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';

class ProfileImgContainer extends StatelessWidget {
  const ProfileImgContainer({Key? key, this.child, this.bgColor})
    : super(key: key);

  final Widget? child;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.profileImgSize,
      width: AppSizes.profileImgSize,
      decoration: BoxDecoration(
        color: bgColor ?? Colors.transparent,
        borderRadius: AppBorders.allSmall,
      ),
      child: child,
    );
  }
}

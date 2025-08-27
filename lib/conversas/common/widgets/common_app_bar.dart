import 'package:ansvel/conversas/common/utilities/utilities.dart';
import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    Key? key,
    this.title,
    this.actions,
    this.fontSize,
    this.centerTitle = false,
  }) : super(key: key);

  final String? title;
  final List<Widget>? actions;
  final bool? centerTitle;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      centerTitle: centerTitle,
      title: Text(
        title ?? '',
        style: context.textStyle.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}

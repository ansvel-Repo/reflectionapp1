import 'package:ansvel/conversas/common/utilities/extensions.dart';
import 'package:flutter/material.dart';

class CommonOutlinedButton extends StatelessWidget {
  const CommonOutlinedButton({super.key, required this.child, this.onPressed});
  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: context.colorScheme.primary),
      ),
      child: child,
    );
  }
}

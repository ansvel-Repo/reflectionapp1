import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';

class StoryBorder extends StatelessWidget {
  const StoryBorder({
    super.key,
    required this.child,
    required this.borderColor,
    this.borderWidth = 2,
  });

  final Widget child;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppBorders.allMedium,
        border: Border.all(width: borderWidth, color: borderColor),
      ),
      padding: AppPaddings.storyItem,
      child: Center(child: child),
    );
  }
}

import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CloseStoryButton extends StatelessWidget {
  const CloseStoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.storyCloseBtn,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(Icons.close, size: AppSizes.large),
        onPressed: context.pop,
      ),
    );
  }
}

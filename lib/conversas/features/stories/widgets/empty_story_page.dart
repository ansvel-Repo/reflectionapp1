import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmptyStoryPage extends StatelessWidget {
  const EmptyStoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: const CommonAppBar(),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppPaddings.allLarge,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DisplayEmptyListMsg(
              msg: l10n.noStoriesAvailable,
              image: AppAssets.noStories,
            ),
            AppSpaces.vLarge,
            ElevatedButton(onPressed: context.pop, child: Text(l10n.close)),
          ],
        ),
      ),
    );
  }
}

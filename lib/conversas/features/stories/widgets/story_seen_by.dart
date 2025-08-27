import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StorySeenBy extends StatelessWidget {
  const StorySeenBy({Key? key, required this.story}) : super(key: key);

  final Story story;

  @override
  Widget build(BuildContext context) {
    final viewersId = story.viewedBy;

    return ListView.separated(
      itemCount: viewersId.length,
      padding: AppPaddings.allLarge,
      itemBuilder: (ctx, index) {
        final viewerId = viewersId[index];

        return StoryViewerTile(
          viewerId: viewerId,
        ).animate(delay: Duration(milliseconds: index * 200)).fadeIn();
      },
      separatorBuilder: (ctx, index) => AppSpaces.vSmall,
    );
  }
}

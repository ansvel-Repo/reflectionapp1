import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:story/story_page_view.dart';
import 'package:flutter/material.dart';

class WatchUserStories extends ConsumerStatefulWidget {
  static WatchUserStories builder(
    AppUser user,
    BuildContext context,
    GoRouterState state,
  ) => WatchUserStories(user: user);
  const WatchUserStories({super.key, required this.user});

  final AppUser user;

  @override
  ConsumerState<WatchUserStories> createState() => _UserStoriesState();
}

class _UserStoriesState extends ConsumerState<WatchUserStories> {
  late ValueNotifier<IndicatorAnimationCommand> _storyController;

  @override
  void initState() {
    super.initState();
    _storyController = ValueNotifier<IndicatorAnimationCommand>(
      IndicatorAnimationCommand.resume,
    );
  }

  @override
  void dispose() {
    _storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final user = widget.user;
    final storiesAsyncValue = ref.watch(getStoriesProvider(user.userId));

    return AsyncValueWidget<Stories>(
      value: storiesAsyncValue,
      data: (allStories) {
        final notExpiredStories = _filterStoriesByExpirationDate(allStories);

        // Check if notExpiredStories is empty
        if (notExpiredStories.isEmpty) {
          return const EmptyStoryPage();
        } else {
          // display stories when notExpiredStories is not empty
          return Scaffold(
            body: StoryPageView(
              key: UniqueKey(),
              showShadow: true,
              indicatorPadding: AppPaddings.indicatorPadding,
              backgroundColor: colors.inversePrimary,
              indicatorAnimationController: _storyController,
              onPageChanged: (index) {},
              itemBuilder: (context, pageIndex, storyIndex) {
                Story? story;

                if (storyIndex >= 0 && storyIndex < notExpiredStories.length) {
                  // Access the story at the specified index
                  story = notExpiredStories[storyIndex];

                  //mark story as seen by the current user
                  _setStoryAsSeen(story);
                }

                return story == null
                    ? const SizedBox.shrink()
                    : Stack(
                        key: UniqueKey(),
                        children: [
                          Positioned.fill(
                            child: DisplayImageFromUrl(
                              imgUrl: story.contentUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          StoryUserInfoHeader(user: user, story: story),
                        ],
                      );
              },
              gestureItemBuilder: (context, pageIndex, storyIndex) {
                final story = notExpiredStories[storyIndex];

                return Stack(
                  children: [
                    const Align(
                      alignment: Alignment.topRight,
                      child: CloseStoryButton(),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: colors.background,
                        padding: AppPaddings.allMedium,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              onPressed: () async {
                                /// To pause the story
                                _pauseStory();

                                //display a list of all users
                                //that seen the story
                                await showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StorySeenBy(story: story);
                                  },

                                  /// To resume the story
                                ).whenComplete(_resumeStory);
                              },
                              icon: Icon(Iconsax.eye, size: AppSizes.small),
                              label: Text('${story.viewedBy.length}'),
                            ),
                            StroyMenu(
                              story: story,
                              onOpened: _pauseStory,
                              onCanceled: _resumeStory,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
              pageLength: 1,
              storyLength: (int pageIndex) => notExpiredStories.length,
              onPageLimitReached: context.pop,
            ),
          );
        }
      },
    );
  }

  void _pauseStory() {
    /// To pause the story
    _storyController.value = IndicatorAnimationCommand.pause;
  }

  void _resumeStory() {
    /// To resume the story
    _storyController.value = IndicatorAnimationCommand.resume;
  }

  //set story as seen
  void _setStoryAsSeen(Story story) async {
    final currentUserId = ref.watch(currentUserIdProvider);
    if (currentUserId != null) {
      final isSeen = story.viewedBy.contains(currentUserId);
      if (!isSeen) {
        await ref.read(setStoryAsSeenProvider(story).future);
      }
    }
  }

  //return only stories that do not expired yet
  Stories _filterStoriesByExpirationDate(Stories stories) {
    final Stories filteredStories = [];
    for (var story in stories) {
      final isExpirationDate = AppHelpers.isExpirationDateArrived(
        story.expirationDate,
      );
      //check if the story does not expired yet
      if (!isExpirationDate) {
        filteredStories.add(story);
      }
    }
    return filteredStories;
  }
}
